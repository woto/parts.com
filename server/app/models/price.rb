class Price < ActiveRecord::Base
  mount_uploader :price, PriceUploader
end
