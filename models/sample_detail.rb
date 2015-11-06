class SampleDetail < ActiveRecord::Base
  belongs_to :account
  belongs_to :send_to_account, :foreign_key => :send_to, :class_name => 'Account'
  belongs_to :video
  
end
