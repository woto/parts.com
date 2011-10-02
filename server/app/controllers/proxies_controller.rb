class ProxiesController < ApplicationController
  # GET /proxies
  # GET /proxies.json
  def index
    #url = "http://www.ip-address.org/"
    url = 'http://hidemyass.com/proxy-list/'
    #url = "http://localhost:3001/parts/"
    agent = Mechanize.new
    values = Mechanize::AGENT_ALIASES.values
    user_agent = values[rand(values.size)]
    agent.user_agent = user_agent
    #agent.set_proxy('127.0.0.1', "8888")
    headers = {"Content-Type" => "application/x-www-form-urlencoded"}
    result = agent.post(url, 'c%5B%5D=United+States&p=&pr%5B%5D=0&a%5B%5D=3&a%5B%5D=4&sp%5B%5D=2&sp%5B%5D=3&ct%5B%5D=2&ct%5B%5D=3&s=0&o=0&pp=2&sortBy=date', headers)
    first_skipped = false
    result.parser.css('table[id=listtable] tr').each do |tr|
      unless first_skipped 
        first_skipped = true
        next
      end
      tds = tr.css('td')
      attr = Hash.new
      attr['source'] = 'hidemyass.com'
      attr['timestamp'] = tds.css('td')[0].attributes['rel'].value.strip
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
    @proxies = Proxy.all

    respond_to do |format|
      format.html { render :text => result.body }
      format.json { render :json => @proxies }
    end
  end

  # GET /proxies/1
  # GET /proxies/1.json
  def show
    @proxy = Proxy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @proxy }
    end
  end

  # GET /proxies/new
  # GET /proxies/new.json
  def new
    @proxy = Proxy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @proxy }
    end
  end

  # GET /proxies/1/edit
  def edit
    @proxy = Proxy.find(params[:id])
  end

  # POST /proxies
  # POST /proxies.json
  def create
    @proxy = Proxy.new(params[:proxy])

    respond_to do |format|
      if @proxy.save
        format.html { redirect_to @proxy, :notice => 'Proxy was successfully created.' }
        format.json { render :json => @proxy, :status => :created, :location => @proxy }
      else
        format.html { render :action => "new" }
        format.json { render :json => @proxy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proxies/1
  # PUT /proxies/1.json
  def update
    @proxy = Proxy.find(params[:id])

    respond_to do |format|
      if @proxy.update_attributes(params[:proxy])
        format.html { redirect_to @proxy, :notice => 'Proxy was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @proxy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proxies/1
  # DELETE /proxies/1.json
  def destroy
    @proxy = Proxy.find(params[:id])
    @proxy.destroy

    respond_to do |format|
      format.html { redirect_to proxies_url }
      format.json { head :ok }
    end
  end
end
