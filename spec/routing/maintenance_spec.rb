describe 'maintenance route', :type => :routing do
  it 'routes /maintenance to the static#maintenance' do
    expect(get(maintenance_path)).to route_to('static#maintenance')
  end
end
