namespace :app do
  desc "Получить список свежих прокси серверов с hidemyass.com"
  task get_proxy_list => :environment do

    ProxyList
  end
end
