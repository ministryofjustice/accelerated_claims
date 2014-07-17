desc 'run all specs with coverage'
task :cover do
  ENV['COVERAGE'] = '1'
  Rake::Task['spec'].invoke
end