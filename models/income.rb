class Income < ActiveRecord::Base
  acts_as_cached
  belongs_to :account
  has_many :income_change_logs
  has_many :default_split_settings, :dependent => :destroy
  has_many :withdraws
  belongs_to :serie

  validates_numericality_of :money, greater_than_or_equal_to:0

  def active?
    return self.active_split_settings.size > 0
  end

  def active_split_setting
    self.active? ? self.active_split_settings.first : nil
  end

  def active_split_settings
    self.default_split_settings.where(["begin_date <= ? and (end_date >= ? or end_date is NULL)",Date.today, Date.today])
  end

  def consumes
    product_ids = self.serie.products.collect{|v| v.id}
    product_item_ids = ProductItem.where(product_id:product_ids).collect{|v| v.id}
    consumes = Consume.where(product_item_id:product_item_ids)
    consumes
  end
end
