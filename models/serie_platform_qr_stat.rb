class SeriePlatformQrStat < ActiveRecord::Base
  #Here the model name SeriePlatformQrStat should be SeriePlatform considering of flexibility.
  belongs_to :platform
  belongs_to :serie
  belongs_to :account
end
