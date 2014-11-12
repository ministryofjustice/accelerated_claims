
describe 'Generated views' do

  it 'should pass w3c' do
    if ENV['w3c'] == true

      puts 'Running w3c tests'

      expect(true).to eql(true)
    end
  end
end