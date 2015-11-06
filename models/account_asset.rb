class AccountAsset < ActiveRecord::Base
  belongs_to :account
  belongs_to :currency
  has_many :account_asset_change_log
  has_many :orders
  has_many :consumes

end
