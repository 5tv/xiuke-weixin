class PkReply < ActiveRecord::Base
	has_ancestry
	validates_presence_of :content, :topic_id, :account_id, :attitude
	belongs_to :topic
	ATTITUDE = {'反方' => 0,'正方' => 1}
end
