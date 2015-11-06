class Topic < ActiveRecord::Base
  validates_presence_of :title, :video_id, :account_id, :video_timeline_point, :duration
  belongs_to :video
  belongs_to :account
  has_many :pk_replies
  has_many :account_topics
  def attr_for_topic_list
    {   
      id:self.id,
      title:self.title,
      video_id:self.video_id,
      account_id:self.account_id,
      video_timeline_point:self.video_timeline_point,
      duration:self.duration,
      end_time:self.video_timeline_point + self.duration,
      affirmative_count:self.affirmative_count == 0 ? 1 : self.affirmative_count,
      negative_count:self.negative_count == 0 ? 1 : self.negative_count,
      created_at:self.created_at,
      updated_at:self.updated_at,
    }
  end

  def affirmative_count
    self.account_topics.pluck(:affirmative_count).sum
  end

  def negative_count
    self.account_topics.pluck(:negative_count).sum
  end

end
