logger Logger.new($stdout)

# Number of processes
worker_processes ENV["UNICORN_WORKERS"].to_i
 
# Time-out
timeout 30
