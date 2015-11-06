class AccountSpecial < ActiveRecord::Base
  acts_as_cached
  belongs_to :account 
  belongs_to :special_for, :polymorphic => true
end
