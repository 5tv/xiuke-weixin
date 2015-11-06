class Commodity < ActiveRecord::Base
  belongs_to :currency
  has_many :commodity_items, dependent: :destroy
  accepts_nested_attributes_for :commodity_items

  def add
    self.commodity_items.each do |commodity_item|
      commodity_item.end_date = get_list_end_date(commodity_item.begin_date, self.commodity_items)
    end
    self.save!
  end

  def set_commodity_item(commodity_data)
    ActiveRecord::Base.transaction do
      commodity_items_data = commodity_data[:commodity_items_attributes].values.sort {|a,b| a[:begin_date].to_date <=> b[:begin_date].to_date}

      old_commodity_item_ids = self.commodity_items.where(["status <> 'delete'"]).collect{|v| v.id.to_s}
      new_commodity_item_ids = commodity_items_data.collect{|v| v[:id].to_s}

      (old_commodity_item_ids - new_commodity_item_ids).each do |delete_commodity_item_id|
        CommodityItem.find(delete_commodity_item_id).update_attribute(:status, "delete")
      end
      
      commodity_items_data.each do |cid|
        if cid[:id].blank?
          commodity_item = self.commodity_items.new(cid)
          commodity_item.end_date = get_list_end_date(cid[:begin_date],commodity_items_data)
          commodity_item.status = "active"
          commodity_item.save!
        else
          commodity_item = self.commodity_items.find(cid[:id])
          commodity_item.discount_type = cid[:discount_type]
          commodity_item.discount_price = cid[:discount_price]
          commodity_item.total_price = cid[:total_price]
          commodity_item.begin_date = cid[:begin_date]
          commodity_item.end_date = get_list_end_date(cid[:begin_date],commodity_items_data)
          commodity_item.save!
        end
      end
    end
  end

  def active?
    return self.active_commodity_item.size > 0
  end

  def acitve_commodity_item
    self.active_commodity_items.size > 0 ? self.active_commodity_items.first : nil
  end

  def active_commodity_items
    self.commodity_items.where("status <> 'delete'").where(["begin_date <= ? and (end_date >= ? or end_date is NULL)",Date.today, Date.today])
  end
  private :active_commodity_items

  def get_list_end_date(begin_date,commodity_item_list)
    after_begin_date_data = commodity_item_list.select {|v| v[:begin_date].to_date > begin_date.to_date}
    end_date = after_begin_date_data.blank? ? nil : after_begin_date_data.first[:begin_date].to_date.yesterday
    end_date
  end
  private :get_list_end_date

end
