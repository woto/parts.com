class Price < ActiveRecord::Base

  COL_SEPS = {
    0 => {:vanila => "fastercsv.Tab", :real => "\t"}, 
    1 => {:vanila => "fastercsv.Comma", :real => ","}, 
    2 => {:vanila => "fastercsv.Semicolon", :real => ";"}
  }

  QUOTE_CHARS = {
    0 => { :vanila => "fastercsv.None", :real => "\xA"}, 
    1 => { :vanila => "fastercsv.Quote", :real => "\""}
  }

  mount_uploader :price, PriceUploader
  validates :price, :presence => true
  before_save :update_asset_attributes
  after_save :import_to_database

  validates :col_sep, :presence => true, :inclusion => {:in => COL_SEPS.map { |k, v| k.to_s}}
  validates :quote_char, :presence => true, :inclusion => {:in => QUOTE_CHARS.map { |k, v| k.to_s}}

  validates :catalog_number_colnum, :presence => true, :numericality => {:only_integer => true }
  validates :manufacturer_colnum, :presence => true, :numericality => {:only_integer => true }

  attr_accessor :catalog_number_colnum, :manufacturer_colnum, :col_sep, :quote_char

  private

  def update_asset_attributes
    if price.present? && price_changed?
      self.file_size = price.file.size
    end
  end

  def import_to_database
    Delayed::Job.enqueue Importer.new(price.current_path, col_sep, quote_char, catalog_number_colnum, manufacturer_colnum)
  end
end
