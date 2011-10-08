require 'config/environment.rb'

options = {
  :backtrace  => true,
  #:ontop      => true,
  :log_output => true,
  :dir_mode => :normal,
  :dir => "#{Rails.root}/tmp/pids/",
  :monitor => true
}

Daemons.run(File.join(Dir.pwd, 'extras', 'ipmyproxy_com.rb'), options)
