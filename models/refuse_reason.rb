class RefuseReason < ActiveRecord::Base
  belongs_to :refuse_for, :polymorphic => true
  belongs_to :account
end
