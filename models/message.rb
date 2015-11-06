class Message < ActiveRecord::Base
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => 'Account'
  belongs_to :account, :foreign_key => :account_id
  belongs_to :messageable, :polymorphic => true
  scope :unread, ->{where(viewed: false)}
  has_many :notices, :as => :noticeable, :dependent => :destroy 

  INDEX_MESSAGE_PER_PAGE = 10
  after_create do
    Notice::NOTICE_DEVICE.each_with_index do |value, index|
     Notice.create(account_id: self.account_id, receiver_id: self.receiver_id, noticeable_type: 'Message', noticeable_id: self.id, device_id: index, send_type_id: Notice::SEND_TYPE_HASH["#{value}"])
    end
  end

  after_update do
    if viewed_changed?
      self.notices.each do |n|
        n.update(viewed: self.viewed, view_time: self.view_time)
      end
    end
  end
end