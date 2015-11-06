class AccountAssetChangeLog < ActiveRecord::Base
  belongs_to :account_asset
  belongs_to :change_by, :polymorphic => true
end
