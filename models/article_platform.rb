class ArticlePlatform < ActiveRecord::Base
  belongs_to :account
  has_many :articles , dependent: :destroy
  validates_presence_of     :platform_type, :platform_id

  PLATFORM_TYPE = ['微信']
end
