# TODO разобраться почему нет доступа без require
require 'extras/hidemyass_com_grabber.rb'

namespace :app do
  desc "Получить список свежих прокси серверов с hidemyass.com"
  task :hidemyass_com_grab => :environment do
    Delayed::Job.enqueue HideMyAssGrabber.new
  end

#  desc "Узнать свой внешний ip адрес и записать в memcached"
#  task :retreive_self_ip => :environment do
#    dc = Dalli::Client.new('localhost:11211')
#    url = 'http://ip.my-proxy.com/'
#    agent = Mechanize.new
#    result = agent.get(url)
#    ip = result.parser.css('table#ip b[style="color:#F00;"]').text
#    raise "Self ip address is not valid" unless ip =~ /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
#      debugger
#    dc.set('ip', ip)
#  end
end
