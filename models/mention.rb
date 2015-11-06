class Mention < ActiveRecord::Base
  belongs_to :mentionable, :polymorphic => true
  has_one :message, :as => :messageable, :dependent => :destroy
  after_create do
    Message.create(account_id: self.account_id, receiver_id: self.receiver_id, messageable_type: 'Mention', messageable_id: self.id)
  end
end
