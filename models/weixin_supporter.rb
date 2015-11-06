class WeixinSupporter < ActiveRecord::Base
  belongs_to :account
  belongs_to :video
  validates_uniqueness_of :unionid, scope: [:account_id, :video_id]
  scope :self, ->{where(role: 0)}
  ROLE = {'creator' => 0, 'participant' => 1}
  STAGE = {'未点击' => 1, '已点击' => 2, '可以抽奖' => 3, '抽奖结果' => 4, '领奖编辑' => 5, '领奖' => 6}
  URL_PREFIX='http://7vilst.com1.z0.glb.clouddn.com/v1/'

  def self.redirect_url(account_id, video_id, unionid)
    if RACK_ENV == 'production'
      url = "http://5tv.com/weixin_supporters/show/#{account_id}/#{video_id}/#{unionid}"
    else
      url = "http://weixintest.5tv.com/weixin_supporters/show/#{account_id}/#{video_id}/#{unionid}"
    end
  end

  before_update do
    if self.stage_changed?
      @ws = WeixinSupporter.find(self.id)
      old = @ws.stage
      if self.stage < old
        self.stage = old
      end
    end 
  end

  # after_create do
  #   begin
  #     if self.role == ROLE['creator']
  #       WeixinStatistic.create(account_id: self.account_id,)
  #     end
  #   rescue
  #     false
  #   end
  # end


end
