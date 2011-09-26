class Processing
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Translation
  extend ActiveModel::Callbacks
    
  attr_accessor :fields
    
  validates :fields, :presence => true
  validates :fields, :numericality => {:only_integer => true}
  
  define_model_callbacks :save
  
  def initialize(attributes={})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def read_attribute_for_validation(key)
    send(key)
  end

  def persisted?
    false
  end
  
  def save
    if valid?
      return true
    else
      return false
    end
  end
end
