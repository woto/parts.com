    url = "http://www.ip-address.org/"
    #url = 'http://hidemyass.com/proxy-list/'
    #url = "http://localhost:3001/parts/"
    @proxy_lists = ProxyList.all
    agent = Mechanize.new
    values = Mechanize::AGENT_ALIASES.values
    user_agent = values[rand(values.size)]
    agent.user_agent = user_agent
    agent.set_proxy('211.140.151.214', "8080")
    headers = {"Content-Type" => "application/x-www-form-urlencoded"}
    result = agent.post(url, 'c%5B%5D=United+States&p=&pr%5B%5D=0&a%5B%5D=3&a%5B%5D=4&sp%5B%5D=2&sp%5B%5D=3&ct%5B%5D=2&ct%5B%5D=3&s=0&o=0&pp=2&sortBy=date', headers)
