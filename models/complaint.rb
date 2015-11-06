class Complaint < ActiveRecord::Base
  belongs_to :complaint_for, :polymorphic => true, :counter_cache => true
  belongs_to :account
  COMPLAINT_FOR_TYPES = ['Account', 'Post', 'Reply', 'Comment', 'Video']
  def with_virtual_attr_for_api
    self.attributes
  end
end
