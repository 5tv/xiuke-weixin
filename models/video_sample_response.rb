class VideoSampleResponse < ActiveRecord::Base
  validates_uniqueness_of :wechat_openid, scope: [:video_id]
  validates_presence_of :wechat_openid
  COMMENT = ['激赏', '赞', '一般', '踩']
  WILL = ['对下集迫不及待', '愿意看', '可看可不看', '不想看了']
  def d_time
    time = self.created_at.in_time_zone('Beijing')
    time.strftime("%m-%d %H:%M")
  end
end
