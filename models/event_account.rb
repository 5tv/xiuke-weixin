class EventAccount < ActiveRecord::Base
  acts_as_cached

  belongs_to :event
  belongs_to :account
  validates_presence_of :email, :phone
  validates_length_of       :email,    :within => 3..100
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :phone,     :with => /\A(\d{11})$\z/

  def self.signed_up(account_id, event_id)
    self.exists?(account_id: account_id, event_id: event_id)
  end

end
