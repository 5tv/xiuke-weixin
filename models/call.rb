class Call < ActiveRecord::Base
  # belongs_to :send_people, :foreign_key => :account_id, :class_name => 'Account'
  # belongs_to :receive_people, :foreign_key => :called_id, :class_name => 'Account'
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => 'Account'
  belongs_to :account, :foreign_key => :account_id
  belongs_to :callable, :polymorphic => true

  after_create do
    Notice.create(account_id: self.account_id, receiver_id: self.receiver_id, noticeable: 'Call', noticeable_id: self.id)
  end
end
