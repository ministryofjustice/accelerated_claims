require 'redis'
require_relative '../spec_helper'
require_relative '../../lib/redis_sweeper'



describe RedisSweeper do


  describe '.new' do

    it 'should raise exception if the applicaition store is not Redis' do
      Rails.application.config.cache_store
      expect(Rails.application.config).to receive(:cache_store).and_return(:memory_store)
      expect {
        RedisSweeper.new
      }.to raise_error RuntimeError, 'Session store does not use redis'
    end
  end


  describe '#run' do

    before(:each)   { expect(Rails.application.config).to receive(:cache_store).and_return( [:redis_store, "redis://localhost:6379/1"])  }

    let(:redis)     { double(Redis) }


    let(:sweeper)   do
      expect(Redis).to receive(:new).with(:url => "redis://localhost:6379/1").and_return(redis)
      expect(Rails.logger).to receive(:info).with(/\[RedisSweeper\] starting at/)
      RedisSweeper.new 
    end


    it 'should run successfully even when there are no keys' do
      expect(Rails.logger).to receive(:info).with('[RedisSweeper] Number of session records in database: 0')
      expect(Rails.logger).to receive(:info).with('[RedisSweeper] 0 sessions deleted')
      expect(redis).to receive(:keys).and_return( [] )
      sweeper.run
    end


    it 'should not delete keys that cannot be deserialized into ActiveSupport::Cache::Entry objects' do
      Timecop.freeze(Time.new(2014, 7, 1, 11, 55, 0, '+00:00')) do
        key_1     = "_session_id:42892fa90e04376438a6a5de78f31bae"
        data_1    = 'serialized_data_for_real_session'
        session_1 = double ActiveSupport::Cache::Entry
        expiry_1  = 1.minute.ago

        key_2     = "_session_id:0e028880f612d9bb4ee800bdb24dc837"
        data_2    = 'serialized_data_for_corrupt_session'
        session_2 = String.new

        expect(Rails.logger).to receive(:info).with('[RedisSweeper] Number of session records in database: 2')
        expect(Rails.logger).to receive(:info).with("[RedisSweeper] deleting session #{key_1} which expired at 2014-07-01 11:54:00")
        expect(Rails.logger).to receive(:info).with('[RedisSweeper] 1 sessions deleted')
        expect(Rails.logger).to receive(:error).with('[RedisSweeper] 1 errors encountered:')
        expect(Rails.logger).to receive(:error).with("[RedisSweeper]    Deserialized object for key #{key_2} is an unexpected class: String")

        expect(redis).to receive(:keys).and_return( [ key_1, key_2 ] )
        expect(redis).to receive(:get).with(key_1).and_return(data_1)
        expect(Marshal).to receive(:load).with(data_1).and_return(session_1)
        expect(session_1).to receive(:is_a?).with(ActiveSupport::Cache::Entry).and_return(true)
        expect(session_1).to receive(:expires_at).and_return(expiry_1)
        expect(redis).to receive(:del).with( [ key_1 ] )
        
        expect(redis).to receive(:get).with(key_2).and_return(data_2)
        expect(Marshal).to receive(:load).with(data_2).and_return(session_2)
        expect(session_2).to receive(:is_a?).with(ActiveSupport::Cache::Entry).and_return(false)
        
        sweeper.run
      end
    end


    it 'should not delete keys where the session is an ActiveSupport::Cache::Entry object by the expires at time cannot be calculated' do
      Timecop.freeze(Time.new(2014, 7, 1, 11, 55, 0, '+00:00')) do
        key_1     = "_session_id:42892fa90e04376438a6a5de78f31bae"
        data_1    = 'serialized_data_for_real_session'
        session_1 = double ActiveSupport::Cache::Entry
        expiry_1  = 1.minute.ago

        key_2     = "_session_id:0e028880f612d9bb4ee800bdb24dc837"
        data_2    = 'serialized_data_for_corrupt_session'
        session_2 = double ActiveSupport::Cache::Entry
        expiry_2  = nil

        expect(Rails.logger).to receive(:info).with('[RedisSweeper] Number of session records in database: 2')
        expect(Rails.logger).to receive(:info).with("[RedisSweeper] deleting session #{key_1} which expired at 2014-07-01 11:54:00")
        expect(Rails.logger).to receive(:info).with('[RedisSweeper] 1 sessions deleted')
        expect(Rails.logger).to receive(:error).with('[RedisSweeper] 1 errors encountered:')
        expect(Rails.logger).to receive(:error).with("[RedisSweeper]    NoMethodError when processing key #{key_2}: undefined method `<' for nil:NilClass")

        expect(redis).to receive(:keys).and_return( [ key_1, key_2 ] )
        expect(redis).to receive(:get).with(key_1).and_return(data_1)
        expect(Marshal).to receive(:load).with(data_1).and_return(session_1)
        expect(session_1).to receive(:is_a?).with(ActiveSupport::Cache::Entry).and_return(true)
        expect(session_1).to receive(:expires_at).and_return(expiry_1)
        expect(redis).to receive(:del).with( [ key_1 ] )
        
        expect(redis).to receive(:get).with(key_2).and_return(data_2)
        expect(Marshal).to receive(:load).with(data_2).and_return(session_2)
        expect(session_2).to receive(:is_a?).with(ActiveSupport::Cache::Entry).and_return(true)
        expect(session_2).to receive(:expires_at).and_return(expiry_2)

        sweeper.run
      end
    end




  end


end