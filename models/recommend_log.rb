class RecommendLog < ActiveRecord::Base
  belongs_to :recommend_for, :polymorphic => true
end
