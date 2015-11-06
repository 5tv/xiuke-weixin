class Vote < ActiveRecord::Base
  belongs_to :election
  belongs_to :account
  belongs_to :voteable, :polymorphic => true, :counter_cache => true
  validates_uniqueness_of :account_id, scope: [:voteable_id, :voteable_type]

  VOTEABLE_TYPES = ['AccountElection']

end
