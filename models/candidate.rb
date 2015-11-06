class Candidate < ActiveRecord::Base
  belongs_to :serie
  belongs_to :candidate_for, :polymorphic => true
  belongs_to :operator, class_name: "Account", foreign_key: "operator_id"
  
end
