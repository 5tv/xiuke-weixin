class AccountTopic < ActiveRecord::Base
	belongs_to :account
	belongs_to :topic
end
