class Price < ActiveRecord::Base
  mount_uploader :price, PriceUploader
  validates :price, :presence => true
  before_save :update_asset_attributes
  after_save :import_to_database

  private

  def update_asset_attributes
    if price.present? && price_changed?
      self.file_size = price.file.size
    end
  end

  def import_to_database
    Delayed::Job.enqueue Importer.new(price.current_path)
  end
end
