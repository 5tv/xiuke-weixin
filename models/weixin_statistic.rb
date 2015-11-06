class WeixinStatistic < ActiveRecord::Base
  belongs_to :account
  belongs_to :video
  STATUS={'资格未使用' => 0, '资格已使用' => 1}
  AWARD_POINTS = {'app_share' => 0}
  before_save do
    if self.clicks_count_changed? and self.status == STATUS['资格未使用'] and self.clicks_count >= 5
      @ws = WeixinSupporter.where(account_id: self.account_id, video_id: self.video_id, role: WeixinSupporter::ROLE['creator']).first
      @ws.update(stage: WeixinSupporter::STAGE['可以抽奖'])
    end
  end
end
