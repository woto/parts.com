namespace :app do
  desc "Получить список свежих прокси серверов с hidemyass.com"
  task :hide_my_ass_com_grabber => :environment do
    Delayed::Job.enqueue HideMyAssComGrabber.new
    puts DateTime.now.to_s + " hidemyass_com поставлен в очередь в Delayed Job"
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
