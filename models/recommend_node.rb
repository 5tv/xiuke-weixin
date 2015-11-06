class RecommendNode < ActiveRecord::Base
  has_many :recommend_settings

  # 用于传递推荐动作者
  attr_accessor :accounting_account_id

  def set_recommend_settig(recommend_settings_data)
    ActiveRecord::Base.transaction do
      recommend_settings_data = recommend_settings_data.values
      old_recommend_setting_ids = self.recommend_settings.collect{|v| v.id.to_s}
      new_recommend_setting_ids = recommend_settings_data.collect{|v| v[:id].to_s}

      (old_recommend_setting_ids - new_recommend_setting_ids).each do |delete_recommend_setting_id|
        # ProductItem.find(delete_product_item_id).update_attribute(:status, "delete")
        RecommendSetting.find(delete_recommend_setting_id).delete
      end

      recommend_settings_data.each do |cid|
        case cid[:setting_for_type]
        when "Serie"
          recommend_for_obj = Serie.where(id:cid[:setting_for_id]).first
          raise "no" unless recommend_for_obj
        else
          raise "recommend for obj erroe"
        end
        
        if cid[:id].blank?
          recommend_setting = self.recommend_settings.new(cid)
          recommend_setting.setting_for = recommend_for_obj
          recommend_setting.action_time = cid[:action_time].to_time
          recommend_setting.action_type = 1
          recommend_setting.operator_id = cid[:accounting_account_id]
          # recommend_setting.save!
        else
          recommend_setting = self.recommend_settings.find(cid[:id])
          recommend_setting.setting_for = recommend_for_obj
          recommend_setting.action_time = cid[:action_time].to_time
          recommend_setting.action_type = 1
          recommend_setting.operator_id = cid[:accounting_account_id]
          # recommend_setting.save!
        end
      end
    end
    
  end


  def orignal_recommend_settig(recommend_settings_data)
    recommend_settings_data = {} unless recommend_settings_data.present? && recommend_settings_data.size > 0
    ActiveRecord::Base.transaction do
      recommend_settings_data = recommend_settings_data.values
      old_recommend_setting_ids = self.recommend_settings.collect{|v| v.id.to_s}
      new_recommend_setting_ids = recommend_settings_data.collect{|v| v[:id].to_s}

      (old_recommend_setting_ids - new_recommend_setting_ids).each do |delete_recommend_setting_id|
        # ProductItem.find(delete_product_item_id).update_attribute(:status, "delete")
        RecommendSetting.find(delete_recommend_setting_id).delete
      end

      recommend_settings_data.each do |cid|
        case cid[:setting_for_type]
        when "Serie"
          recommend_for_obj = Serie.where(id:cid[:setting_for_id]).first
          raise "no" unless recommend_for_obj
        else
          raise "recommend for obj erroe"
        end
        
        if cid[:id].blank?
          recommend_setting = self.recommend_settings.new(cid)
          recommend_setting.setting_for = recommend_for_obj
          recommend_setting.action_time = cid[:action_time].to_time
          recommend_setting.action_type = 1
          recommend_setting.operator_id = cid[:accounting_account_id]
          recommend_setting.save!
        else
          recommend_setting = self.recommend_settings.find(cid[:id])
          recommend_setting.setting_for = recommend_for_obj
          recommend_setting.action_time = cid[:action_time].to_time
          recommend_setting.action_type = 1
          recommend_setting.operator_id = cid[:accounting_account_id]
          recommend_setting.recommend_order = cid[:recommend_order]
          recommend_setting.save!
        end
      end
    end
  end
end
