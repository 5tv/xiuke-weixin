class WatchRecord < ActiveRecord::Base
	validates_presence_of :video_id, :account_id, :video_timeline_point
	belongs_to :account
	def attr_for_watch_history
		{   
			id:self.id,
			video_id:self.video_id,
			video_cover:self.video.cover.x200.url,
			video_title:self.video.title,
			video_episode:self.video.episode,
			total_episodes:self.serie.videos.pluck(:episode).sort.last,
			video_timeline_point:self.video_timeline_point,
			video_duration:self.video.duration,
			account_id:self.account_id,
			serie_id:self.serie.id,
			serie_title:self.serie.title,
			deleted:self.deleted,
			created_at:self.created_at,
			updated_at:self.updated_at
		}
	end

	def video
		Video.where(id:self.video_id).first
	end

	def serie
		Serie.where(id:self.video.serie_id).first
	end

end
