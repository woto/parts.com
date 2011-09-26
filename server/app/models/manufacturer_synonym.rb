class ManufacturerSynonym < ActiveRecord::Base
  belongs_to :manufacturer
  validates :title, :presence => true, :uniqueness => true
  validates :manufacturer, :presence => true
end
