class LotteryAddress < ActiveRecord::Base
  belongs_to :account
  belongs_to :video
  belongs_to :lottery
  validates_presence_of :lottery_id
end
