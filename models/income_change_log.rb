class IncomeChangeLog < ActiveRecord::Base
  acts_as_cached
  belongs_to :income
  belongs_to :change_by, :polymorphic => true
  belongs_to :account
  INCOME_CHANGE_TYPE = ['Consume', 'Withdraw']
end
