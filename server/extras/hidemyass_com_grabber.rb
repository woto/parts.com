class HideMyAssGrabber
  def perform
    url = 'http://hidemyass.com/proxy-list/'
    agent = Mechanize.new
    values = Mechanize::AGENT_ALIASES.values
    values.shift
    agent.user_agent = values[rand(values.size)]
    # TODO тут сделать использование прокси
    #agent.set_proxy('127.0.0.1', "8888")
    headers = {"Content-Type" => "application/x-www-form-urlencoded"}
    result = agent.post(url, 'ac=on&c%5B%5D=China&c%5B%5D=Hong+Kong&c%5B%5D=Indonesia&c%5B%5D=United+States&c%5B%5D=Brazil&c%5B%5D=Russian+Federation&c%5B%5D=Taiwan%2C+Republic+of+China&c%5B%5D=Korea%2C+Republic+of&c%5B%5D=India&c%5B%5D=Thailand&c%5B%5D=Colombia&c%5B%5D=Egypt&c%5B%5D=Ukraine&c%5B%5D=Iran&c%5B%5D=Ecuador&c%5B%5D=Turkey&c%5B%5D=Argentina&c%5B%5D=Bangladesh&c%5B%5D=Poland&c%5B%5D=Germany&c%5B%5D=Venezuela&c%5B%5D=Hungary&c%5B%5D=France&c%5B%5D=Japan&c%5B%5D=Viet+Nam&c%5B%5D=Romania&c%5B%5D=Kazakhstan&c%5B%5D=Chile&c%5B%5D=Italy&c%5B%5D=Kenya&c%5B%5D=United+Kingdom&c%5B%5D=South+Africa&c%5B%5D=Czech+Republic&c%5B%5D=Peru&c%5B%5D=Canada&c%5B%5D=Mexico&c%5B%5D=United+Arab+Emirates&c%5B%5D=Nigeria&c%5B%5D=Bulgaria&c%5B%5D=Malaysia&c%5B%5D=Cambodia&c%5B%5D=Brunei+Darussalam&c%5B%5D=Netherlands&c%5B%5D=Australia&c%5B%5D=Slovakia&c%5B%5D=Albania&c%5B%5D=Kuwait&c%5B%5D=Switzerland&c%5B%5D=Denmark&c%5B%5D=Singapore&c%5B%5D=Latvia&c%5B%5D=Moldova%2C+Republic+of&c%5B%5D=Philippines&c%5B%5D=Pakistan&c%5B%5D=Azerbaijan&c%5B%5D=Lithuania&c%5B%5D=Israel&c%5B%5D=Sweden&c%5B%5D=Norway&c%5B%5D=Puerto+Rico&c%5B%5D=Equatorial+Guinea&c%5B%5D=Lao+PDR&c%5B%5D=Serbia&c%5B%5D=Zambia&c%5B%5D=Nepal&c%5B%5D=Bosnia+and+Herzegovina&c%5B%5D=Paraguay&c%5B%5D=Zimbabwe&c%5B%5D=Spain&c%5B%5D=Croatia&c%5B%5D=Dominican+Republic&c%5B%5D=Ireland&c%5B%5D=Syrian+Arab+Republic&c%5B%5D=Jamaica&c%5B%5D=Namibia&c%5B%5D=Uzbekistan&c%5B%5D=Uganda&c%5B%5D=Greece&c%5B%5D=Palestinian+Territory%2C+Occupied&c%5B%5D=Botswana&c%5B%5D=Gibraltar&c%5B%5D=Gambia&c%5B%5D=Luxembourg&c%5B%5D=Ghana&c%5B%5D=Costa+Rica&c%5B%5D=Lebanon&c%5B%5D=Iraq&c%5B%5D=Austria&c%5B%5D=Saudi+Arabia&c%5B%5D=New+Zealand&c%5B%5D=Bolivia&c%5B%5D=Morocco&c%5B%5D=Mali&c%5B%5D=Afghanistan&c%5B%5D=Belarus&c%5B%5D=Benin&c%5B%5D=Cote+D%27Ivoire&c%5B%5D=Chad&p=&pr%5B%5D=0&pr%5B%5D=1&a%5B%5D=3&a%5B%5D=4&sp%5B%5D=3&ct%5B%5D=3&s=0&o=0&pp=3&sortBy=date', headers)
    first_skipped = false
    result.parser.css('table[id=listtable] tr').each do |tr|
      unless first_skipped 
        first_skipped = true
        next
      end
      tds = tr.css('td')
      attr = {}
      attr['source'] = 'hidemyass.com'
      attr['timestamp'] = Time.at(tds.css('td')[0].attributes['rel'].value.strip.to_i)
      attr['ip'] = tds.css('td')[1].child.text.strip
      attr['port'] = tds.css('td')[2].text.strip
      attr['country'] = tds.css('td')[3].child.text.strip
      attr['speed'] = tds.css('td')[4].children[1].children[1].attributes["style"].value.match(/:(\d+)%/)[1]
      attr['connection_time'] = tds.css('td')[5].children[1].children[1].attributes["style"].value.match(/:(\d+)%/)[1]
      attr['protocol'] = tds.css('td')[6].child.text.strip
      attr['anonymity'] = tds.css('td')[7].child.text.strip

      proxy = Proxy.where(:ip => attr['ip'], :port => attr['port']).first

      if proxy.present?
        proxy.update_attributes(attr)
      else
        Proxy.create!(attr)
      end

    end
  end
end
