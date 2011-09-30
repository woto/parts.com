class Part < ActiveRecord::Base
  belongs_to :manufacturer
  validates :manufacturer, :presence => true
  validates :catalog_number, :presence => true, :uniqueness => {:scope => :manufacturer_id}

  before_save :change_status

  def change_status
    if price_changed?
      self.price_updated = DateTime.now
    end

    #debugger
    #self.locked = false
  end
end
