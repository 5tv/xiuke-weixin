class ProductSplitSetting < ActiveRecord::Base
  belongs_to :product
  belongs_to :income
end
