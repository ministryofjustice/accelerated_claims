require 'rspec'

describe 'My behaviour' do
  if ENV['w3c'] == true

    it 'should do something' do

      puts 'Running w3c tests'


      expect(true).to eql(true)
    end
  end
end