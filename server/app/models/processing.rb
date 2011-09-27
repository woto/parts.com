class Processing
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Translation
  extend ActiveModel::Callbacks
    
  attr_accessor :fields
  attr_accessor :datetime
    
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
      keys = {}
      Part.joins(:manufacturer).all.each_with_index do |part, i|
       keys["partNumber#{i}"] = part.catalog_number
       keys["makeid#{i}"] = part.manufacturer.parts_com_id
      end
      agent = Mechanize.new
      result = agent.post('http://www.parts.com/oemcatalog/index.cfm?action=getMultiSearchItems&siteid=2&items=30', keys)
      return result.search("table[1] table table")
    else
      return false
    end
  end
end
