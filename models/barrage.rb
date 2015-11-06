class Barrage < ActiveRecord::Base
	validates_presence_of :video_id, :account_id, :video_timeline_point
	belongs_to :video
	belongs_to :account
	def attr_for_barrage_list
		{   
			id:self.id,
			content:self.content,
			video_id:self.video_id,
			account_id:self.account_id,
			video_timeline_point:self.video_timeline_point,
			created_at:self.created_at,
			updated_at:self.updated_at,
		}
	end
end
