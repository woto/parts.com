require '../config/environment.rb'

options = {
  :backtrace  => true,
  :ontop      => true,
  :log_output => true,
  :dir_mode => :normal,
  :dir => "#{Rails.root}/tmp/pids/"
}

Daemons.run(File.join(Dir.pwd, 'ipmyproxy_com.rb'), options)
