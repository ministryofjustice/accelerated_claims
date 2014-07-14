logger Logger.new($stdout)

# Number of processes
worker_processes ENV["UNICORN_WORKERS"]
 
# Time-out
timeout 30
