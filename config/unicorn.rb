module Rails
  class <<self
    def root
      File.expand_path("../..", __FILE__)
    end
  end
end
puts Rails.root
rails_env = ENV["RAILS_ENV"] || "production"

preload_app true
working_directory Rails.root
pid "#{Rails.root}/tmp/pids/unicorn.pid"
stderr_path "#{Rails.root}/log/unicorn.log"
stdout_path "#{Rails.root}/log/unicorn.log"

listen 5000, :tcp_nopush => false
listen "/tmp/unicorn.lehazi.sock"
worker_processes 4

#listen 6000, :tcp_nopush => false
#listen "/tmp/unicorn.caijitie.sock"
#worker_processes 2 

timeout 120

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{Rails.root}/Gemfile"
end

before_fork do |server, worker|
  old_pid = "#{Rails.root}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Send 'QUIT' signal to unicorn error!"
    end
  end
end
