class Qrstat < ActiveRecord::Base
  acts_as_cached
  belongs_to :account
  has_many :qrstat_logs, :dependent => :destroy

  validates_presence_of  :url, :channel, :account_id, :channel_name
  validates_uniqueness_of :channel, :channel_name

end