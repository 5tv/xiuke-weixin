class Product < ActiveRecord::Base
  belongs_to :serie
  belongs_to :product_for, :polymorphic => true
  has_many :card_codes
  has_many :product_items, dependent: :destroy
  has_many :product_split_settings, dependent: :destroy
  accepts_nested_attributes_for :product_items

  attr_accessor :product_for_obj

  def free?
    return this.price.to_i == 0
  end

  def add
    ActiveRecord::Base.transaction do
      self.product_items.each do |product_item|
        product_item.end_date = get_list_end_date(product_item.begin_date, self.product_items)
      end
      unless self.serie.is_has_product
        self.serie.update(is_has_product: true)
      end
      self.save!
    end
  end

  def original_update(product_data)
    ActiveRecord::Base.transaction do
      self.update_attribute(:price,product_data[:price])

      product_items_data = product_data[:product_items_attributes].values.sort {|a,b| a[:begin_date].to_date <=> b[:begin_date].to_date}

      #old_product_item_ids = self.product_items.where(["status <> 'delete'"]).collect{|v| v.id.to_s}
      old_product_item_ids = self.product_items.collect{|v| v.id.to_s}
      new_product_item_ids = product_items_data.collect{|v| v[:id].to_s}

      (old_product_item_ids - new_product_item_ids).each do |delete_product_item_id|
        # ProductItem.find(delete_product_item_id).update_attribute(:status, "delete")
        ProductItem.find(delete_product_item_id).delete
      end
      
      product_items_data.each do |cid|
        if cid[:id].blank?
          product_item = self.product_items.new(cid)
          product_item.end_date = get_list_end_date(cid[:begin_date],product_items_data)
          #product_item.status = "active"
          product_item.save!
        else
          product_item = self.product_items.find(cid[:id])
          product_item.discount_type = cid[:discount_type]
          product_item.discount_price = cid[:discount_price]
          product_item.currency_id = cid[:currency_id]
          product_item.currency_num = cid[:currency_num]
          product_item.use_type = cid[:use_type]
          product_item.end_date = get_list_end_date(cid[:begin_date],product_items_data)
          product_item.save!
        end
      end
    end
  end

  def title
    case product_for_type
    when "Video"
      serie.is_has_season ? product_for.season.real_title + " #{product_for.episode_or_type}" : product_for.title + " #{product_for.episode_or_type}"
    when "Season"
      self.product_for.real_title
    when "Serie"
      self.product_for.title+"整系列"
    end
  end

  def active?
    return self.active_product_items.size > 0
  end

  def active_product_item
    self.active_product_items.size > 0 ? self.active_product_items.first : nil
  end

  def active_product_items
    self.product_items.where(["begin_date <= ? and (end_date >= ? or end_date is NULL)",Date.today, Date.today])
  end

  def get_list_end_date(begin_date,commodity_item_list)
    after_begin_date_data = commodity_item_list.select {|v| v[:begin_date].to_date > begin_date.to_date}
    end_date = after_begin_date_data.blank? ? nil : after_begin_date_data.first[:begin_date].to_date.yesterday
    end_date
  end
  private :get_list_end_date

  def pay
  end
end
