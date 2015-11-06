class AccountVideo < ActiveRecord::Base
  # belongs_to :account
  belongs_to :video
  belongs_to :account
  ACTION_TYPE = {"play" => 1, "download" => 2}
  
  before_save do
    if self.request.present?
      user_agent =  self.request.split("\", \"").select{|i| i.include?("HTTP_USER_AGENT") }.first.split("=>").last
      if user_agent.include?("MicroMessenger")
        self.playing_source = "weixin"
      end
    end
  end

  after_create do      
    v = self.video

    case self.action_type
    when ACTION_TYPE["play"]
      if Video::MILESTONE_NUM.include?(v.play_count + 1)
        Activity.create(account_id: self.account_id, serie_id: v.serie_id, 
          activityable_type: "AccountVideo", activityable_id: self.id, action_name: "create", 
          memo: "#{self.account.name}第#{v.play_count + 1}次播放了视频#{v.title}")
      end
      v.update_attribute(:play_count, v.play_count + 1)
    when ACTION_TYPE["download"]
      if Video::MILESTONE_NUM.include?(v.cached_count + 1)
        Activity.create(account_id: self.account_id, serie_id: v.serie_id, 
          activityable_type: "AccountVideo", activityable_id: self.id, action_name: "create", 
          memo: "#{self.account.name}第#{v.cached_count + 1}次下载了视频#{v.title}")
      end
      v.update_attribute(:cached_count, v.cached_count + 1)
    end
  end

  def with_virtual_attr_for_api
    temp = self.attributes
    ['platform, tags, request'].each do |item| 
      temp.delete(item)
    end
    temp.merge!({
      'account' => self.account.with_virtual_attr_for_api
      })
    temp
  end


end
