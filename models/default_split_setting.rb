class DefaultSplitSetting < ActiveRecord::Base
  belongs_to :income

  def self.create_many(default_split_settings, income_id)
    ActiveRecord::Base.transaction do
      default_split_settings.each do |default_split_setting_data|
        default_split_setting = DefaultSplitSetting.new(default_split_setting_data)
        default_split_setting.income_id = income_id
        default_split_setting.end_date = get_list_end_date(default_split_setting.begin_date, default_split_settings)
        default_split_setting.save!
      end
    end
  end

  def self.update_many(default_split_settings, income_id)
    income = Income.find(income_id)

    default_split_settings_data = default_split_settings.sort {|a,b| a[:begin_date].to_date <=> b[:begin_date].to_date}

    old_split_settings_item_ids = income.default_split_settings.collect{|v| v.id.to_s}
    new_split_settings_item_ids = default_split_settings_data.collect{|v| v[:id].to_s}

    ActiveRecord::Base.transaction do
      (old_split_settings_item_ids - new_split_settings_item_ids).each do |delete_split_settings_item_id|
        DefaultSplitSetting.find(delete_split_settings_item_id).update_attribute(:status, "delete")
      end
      default_split_settings_data.each do |dssd|
        if dssd[:id].blank?
          default_split_setting = income.default_split_settings.new(dssd)
          default_split_setting.end_date = get_list_end_date(dssd[:begin_date],default_split_settings_data)
          #product_item.status = "active"
          default_split_setting.save!
        else
          default_split_setting = income.default_split_settings.find(dssd[:id])
          default_split_setting.begin_date = dssd[:begin_date]
          default_split_setting.split_num = dssd[:split_num]
          default_split_setting.end_date = get_list_end_date(dssd[:begin_date],default_split_settings_data)
          default_split_setting.save!
        end
      end
    end
  end

  def self.get_list_end_date(begin_date,commodity_item_list)
    after_begin_date_data = commodity_item_list.select {|v| v[:begin_date].to_date > begin_date.to_date}
    end_date = after_begin_date_data.blank? ? nil : after_begin_date_data.first[:begin_date].to_date.yesterday
    end_date
  end

  def shown_end_date
    end_date ? (end_date+1.day - 1.seconds).strftime("%Y-%m-%d %H:%M:%S") : "-" 
  end
end
