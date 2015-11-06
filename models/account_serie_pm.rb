class AccountSeriePm < ActiveRecord::Base
  acts_as_cached
  belongs_to :account
  belongs_to :serie
end
