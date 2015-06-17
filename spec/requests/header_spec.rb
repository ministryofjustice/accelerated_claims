require 'spec_helper'

RSpec.describe 'Custom headers check' do
  before do
    WebMock.disable_net_connect!(allow: ['127.0.0.1', /codeclimate.com/])
    get '/'
  end

  it 'verify that custom headers are set' do
    expect(response['X-Frame-Options']).to eq ''
    expect(response['X-Content-Type-Options']).to eq ''
    expect(response['X-XSS-Protection']).to eq ''
    expect(response['Pragma']).to eq ''
    expect(response['Cache-Control']).to eq ''
    expect(response['Expires']).to eq ''
  end
end
