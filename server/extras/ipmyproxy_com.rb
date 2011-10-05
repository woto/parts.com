ActiveRecord::Base.logger = ActiveSupport::BufferedLogger.new(File.join(Rails.root, 'log', 'ipmyproxy_com', "#{Rails.env}.log"))
Rails.logger = ActiveSupport::BufferedLogger.new(File.join(Rails.root, 'log', 'ipmyproxy_com', "#{Rails.env}.log"))

class IpmyproxyCom
  def perform
    while true
      Proxy.where('good BETWEEN ? AND ?', -9, 9).each do |proxy|
        begin
          Timeout::timeout(15) do
            agent = Mechanize.new
            values = Mechanize::AGENT_ALIASES.values
            values.shift
            agent.user_agent = values[rand(values.size)]
            agent.set_proxy(proxy.ip, proxy.port)
            result = agent.post('http://ip.my-proxy.com/')
            begin
              Proxy.transaction do
                if result.body =~ /#{Regexp.escape('No proxy detected.')}/
                  proxy.good = proxy.good + 3
                else
                  proxy.good = AppConfig.min_good
                end
                proxy.check = result.parser.css('div#proxy2 span').text
                proxy.save
              end
            rescue => e
              debugger
              puts e
            end
          end
        rescue Timeout::Error, Net::HTTP::Persistent::Error,Net::HTTPMethodNotAllowed, Net::HTTPServiceUnavailable, Mechanize::ResponseCodeError, Errno::ECONNREFUSED, Errno::ETIMEDOUT => e
          begin
            Proxy.transaction do
              proxy.decrement(:good)
              proxy.check = e.message
              proxy.save
            end
          rescue => e
            debugger
            puts e
          end
        end
        sleep 5
      end
    end
  end
end

IpmyproxyCom.new.perform
