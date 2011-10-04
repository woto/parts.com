class AddIpIndexToProxies < ActiveRecord::Migration
  def change
    add_index(:proxies, :ip)
  end
end
