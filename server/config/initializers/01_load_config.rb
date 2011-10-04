class AppConfig 
  protected

  def self.config
    @@config ||= YAML.load_file("#{Rails.root}/config/config.yml")[::Rails.env].symbolize_keys
  end

  def self.method_missing method_name
    if config.has_key? method_name
      config[method_name]
    else
      super
    end
  end
end
