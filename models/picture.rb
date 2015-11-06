class Picture < ActiveRecord::Base
  acts_as_cached

  belongs_to :account
  belongs_to :pictureable, :polymorphic => true, :counter_cache => true
  mount_uploader :attachment, ImageUploader

  PICTUREABLE_TYPE = ['Post', 'Reply', 'HomeTop']

  
  def with_virtual_attr
    self.attributes
  end

  def with_virtual_attr_for_api
    {
      url: self.attachment.url,
      position: self.position
    }
  end

end
