class Consume < ActiveRecord::Base
  belongs_to :product_item
  belongs_to :account
  belongs_to :account_asset
  belongs_to :card_code
  belongs_to :currency
  has_many :transactions, :as => :trade_for, :dependent => :destroy
  has_many :income_change_logs, :as => :change_by, :dependent => :destroy

  def validate_account_asset(commodiy_id, account_id)
    commodity_price = Commodity.find(commodity_id).active_commodity_item.total_price
    account_asset_num = Account.find(account_id).account_asset.num
    raise "asset not enough" if account_asset_num < commodity_price
  end
  private :validate_account_asset

  def self.add(product_id,account_id)
    product_item = Product.find(product_id).active_product_item
    account_asset = Account.find(account_id).account_asset
    consume = Consume.new
    consume.account_id = account_id
    consume.account_asset_id = account_asset.id
    consume.product_item_id = product_item.id
    consume.currency_id = product_item.currency_id
    consume.currency_num = product_item.currency_num
    consume.discount_type = product_item.discount_type
    consume.discount_price = product_item.discount_price
    consume.status = "waiting"
    consume.save!
    consume
  end

  def pay
    ActiveRecord::Base.transaction do
      self.status = "success"
      self.save!

      product_item = self.product_item
      account_asset = self.account_asset 
      old_asset_num = account_asset.num
      new_asset_num = account_asset.num - self.currency_num

      account_asset.num = new_asset_num 
      account_asset.save!
#TODO
      asset_change_log = account_asset.account_asset_change_log.new 
      asset_change_log.before_num = old_asset_num
      asset_change_log.after_num = new_asset_num
      asset_change_log.change_by = self
      asset_change_log.save!

      account_special = AccountSpecial.new
      account_special.account_id = account_asset.account_id
      account_special.special_for = product_item.product.product_for
      account_special.save!

      serie = product_item.product.serie
      income = serie.income

      default_split_setting = income.active_split_setting

      old_money = income.money
      new_money = income.money + self.currency_num * default_split_setting.split_num

      income.money = new_money
      income.save!
#TODO
      income_change_log = income.income_change_logs.new
      income_change_log.before_num = old_money
      income_change_log.after_num = new_money
      income_change_log.change_by = self
      income_change_log.save!

    end
  end

  def pay_by_card(card_id)
    
  end
end
