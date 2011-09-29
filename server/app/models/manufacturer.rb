class Manufacturer < ActiveRecord::Base
  has_many :manufacturer_synonyms
  validates :parts_com_id, :numericality => {:only_integer => true, :greater_than_or_equal => 0}
  validates :title, :presence => true, :uniqueness => true
  has_many :parts
end
