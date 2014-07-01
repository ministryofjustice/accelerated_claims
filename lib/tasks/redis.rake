namespace :redis do

  desc 'sweeps stale sessions from the redis session database'
  task :sweep => :environment do
    require "#{Rails.root}/lib/redis_sweeper"
    RedisSweeper.new.run
  end
end

