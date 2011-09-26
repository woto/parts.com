class Part < ActiveRecord::Base
  belongs_to :manufacturer
  validates :manufacturer, :presence => true
  validates :catalog_number, :presence => true
end
