class Part < ActiveRecord::Base
  belongs_to :manufacturer
  validates :manufacturer, :presence => true
  validates :catalog_number, :presence => true, :uniqueness => {:scope => :manufacturer_id}

  before_save :update_price_updated

  def update_price_updated
    if price_changed?
      self.price_updated = DateTime.now
    end
  end
end
