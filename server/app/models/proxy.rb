class Proxy < ActiveRecord::Base
  @ip_regex = /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/
  validates :ip, :presence => true, :uniqueness => true, :format => {:with => @ip_regex}
  validates :good, :presence => true, :numericality => {:only_integer => true}
  validates :port, :presence => true, :numericality => {:only_integer => true}
  validates :speed, :numericality => {:only_integer => true}, :allow_blank => true
  validates :connection_time, :allow_blank => true, :numericality => {:only_integer => true}
  validates :protocol, :inclusion => {:in => ["HTTP", "HTTPS"]}, :allow_blank => true

end
