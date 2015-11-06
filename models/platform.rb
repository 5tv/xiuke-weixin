class Platform < ActiveRecord::Base
  has_many :serie_platform_qr_stats, dependent: :destroy 
  has_many :series, :through => :serie_platform_qr_stats 
  has_many :platform_statistics, dependent: :destroy 
end
