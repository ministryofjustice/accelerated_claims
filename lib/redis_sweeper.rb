
# erases out-of-date session records from the redis database

class RedisSweeper

  def initialize
    session_store = Rails.application.config.cache_store
    raise "Session store does not use redis" unless session_store.is_a?(Array) && session_store.first == :redis_store

    @redis          = Redis.new(:url => session_store.last)
    @errors         = []
    @now            = Time.now
    @keys_to_delete = []
    Rails.logger.info "[RedisSweeper] starting at #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}" 
  end
  



  def run
    keys = @redis.keys
    Rails.logger.info "[RedisSweeper] Number of session records in database: #{keys.size}"
    keys.each { |k| print_details(k) }   
    @redis.del @keys_to_delete unless @keys_to_delete.empty?
    Rails.logger.info "[RedisSweeper] #{@keys_to_delete.size} sessions deleted"
    unless @errors.empty?
      Rails.logger.error "[RedisSweeper] #{@errors.size} errors encountered:"
      @errors.each { |e| Rails.logger.error "[RedisSweeper]    #{e}"}
    end
  end


  private


  def print_details(key)
    serialized_session = @redis.get(key)
    begin
      session = Marshal.load(serialized_session)
      if session.is_a?(ActiveSupport::Cache::Entry)
        expires_at = session.expires_at
        if expires_at < Time.now
          @keys_to_delete << key
          Rails.logger.info "[RedisSweeper] deleting session #{key} which expired at #{expires_at.strftime('%Y-%m-%d %H:%M:%S')}"
        end
      else
        @errors << "Deserialized object for key #{key} is an unexpected class: #{session.class}"
      end
    rescue => err
      @errors << "#{err.class} when processing key #{key}: #{err.message}"
    end
  end



end