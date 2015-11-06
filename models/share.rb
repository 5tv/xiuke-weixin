#coding: utf-8
class Share < ActiveRecord::Base
  belongs_to :shareable, :polymorphic => true, :counter_cache => true
  belongs_to :account

  SHAREABLE_TYPES = ['Video', 'Topic', 'Reply', 'AccountElection', 'Post']
  PLATFORM_ID = { '微信' => 1, '新浪微博' => 2, '腾讯微博' => 3 }

  after_create do
    if self.shareable_type == "Video"
      v = self.shareable
      if Video::MILESTONE_NUM.include?(v.play_count + 1)
        Activity.create(account_id: self.account_id, serie_id: v.serie_id, 
          activityable_type: "Share", activityable_id: self.id, action_name: "create", 
          memo: "第#{v.episode}集已被分享#{v.play_count + 1}次。")
      end
    end
    Rule.add_score_detail(self.account_id, self.shareable.serie_id, self, 'create')
  end
end
