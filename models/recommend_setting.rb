class RecommendSetting < ActiveRecord::Base
  belongs_to :setting_for, :polymorphic => true
  STATUS = {"未执行" => 0, "已执行" => 1, "删除" => 2}
  default_scope { order("recommend_order ASC") }

  after_create do
    if self.setting_for_type == "Serie"
      Candidate.where(serie_id:self.setting_for_id).delete_all
    end    
  end
end