class Order < ActiveRecord::Base
  belongs_to :account
  belongs_to :account_asset
  belongs_to :commodity_item
  has_many :asset_change_log, :as => :change_by, :dependent => :destroy
  has_many :transactions, :as => :trade_for, :dependent => :destroy

  def validate_order_data(commodiy_id, account_id)
    validate_commodity_status(commodiy_id, account_id)
  end

  def validate_commodity_status(commodiy_id, account_id)
    commodity = Commodity.find(commodity_id)
    raise "commodity inactive" if commodity.active?
  end
  private :validate_commodity_status

  def self.add(commodity_id,account_id)
    commodity_item = Commodity.find(commodity_id).active_commodity_item
    account_asset = Account.find(account_id).account_asset
    order = self.new
    order.account_id = account_id
    order.account_asset_id = account_asset_id
    order.commodity_id = commodity_id
    order.commodity_item_id = commodity_item_id
    order.discount_type = commodity_item.discount_type
    order.discount_prce = commodity_item.discount_prce
    order.total_price = commodity_item.total_price
    order.status = "waiting"
    order.save!
    order
  end

  def pay
    ActiveRecord::Base.transaction do
      self.status = "success"
      self.save!

      commodity_item = self.commodity_item
      account_asset = self.account_asset 
      old_asset_num = account_asset.num
      new_asset_num = account_asset.num + self.commodity_item.num

      account_asset.num = new_asset_num 
      account_asset.save!

      asset_change_log = account_asset.asset_change_log.new 
      asset_change_log.before_num = old_asset_num
      asset_change_log.after_num = new_asset_num
      asset_change_log.change_by = self
      asset_change_log.save!
    end
  end
end
