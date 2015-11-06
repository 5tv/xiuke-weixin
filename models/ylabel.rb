class Ylabel < ActiveRecord::Base
  # include Redis::Search
  belongs_to :xlabel_list
  belongs_to :ylabelable, :polymorphic => true
  validates_uniqueness_of :xlabel_list_id, scope: [:ylabelable_type, :ylabelable_id]
end
