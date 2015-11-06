class AppDownloadInfo < ActiveRecord::Base
  belongs_to :app_address
  belongs_to :video, :counter_cache => true

  scope :wechat_iphone, -> { where(platform: "wechat iPhone") }
  scope :wechat_android, -> { where(platform: "wechat mobile") }
  scope :other_iphone, -> { where(platform: "other iPhone") }
  scope :other_android, -> { where(platform: "other mobile") }

end
