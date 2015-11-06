class QrstatLog < ActiveRecord::Base
  acts_as_cached
  belongs_to :qrstat, counter_cache: true

  validates_presence_of  :qrstat_id

end