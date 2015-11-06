class Like < ActiveRecord::Base
  acts_as_cached
  belongs_to :likeable, :polymorphic => true, :counter_cache => true
  belongs_to :account
  validates_uniqueness_of :account_id, scope: [:likeable_id, :likeable_type]
  has_one :message, :as => :messageable, :dependent => :destroy

  LIKEABLE_TYPES = ['Video', 'Serie', 'Reply', 'Post']
  LIKEABLE_NAMES = {'Video' => '视频', 'Serie' =>'系列' , 'Topic' =>'话题' , 'Reply' =>'回复' , 'Comment' =>'评论' ,'Post' => '帖子'}

  after_create do
    if self.likeable_type == "Video"
      v = self.likeable
      if Video::MILESTONE_NUM.include?(v.play_count + 1)
        Activity.create(account_id: self.account_id, serie_id: v.serie_id, 
          activityable_type: "Like", activityable_id: self.id, action_name: "create", 
          memo: "#{self.account.name}第#{v.play_count + 1}次喜欢了视频#{v.title}")
      end
    end

    if self.likeable_type == "Answer" && self.liked == false
      dislikes_count = self.likeable.dislikes_count
      self.likeable.update_attribute(:dislikes_count, dislikes_count + 1 )
    end

    if self.likeable_type == "Comment" && self.liked == false
      dislikes_count = self.likeable.dislikes_count
      self.likeable.update_attribute(:dislikes_count, dislikes_count + 1 )
    end

    case self.likeable.class.name
    when "Node","Post"
      serie_id = self.likeable.serie_id
    when "Reply"
      serie_id = self.likeable.replyable.serie_id
    when "Comment"
      serie_id = self.likeable.reply.replyable.serie_id
    when "Video"
      serie_id = self.likeable.serie_id
    end
    case self.likeable_type
    when 'Video'
      PersonalId.find_or_create_by(account_id: self.account_id).atomic_append(:like_videos, self.likeable_id) rescue true
    when 'Post'
      PersonalId.find_or_create_by(account_id: self.account_id).atomic_append(:like_posts, self.likeable_id) rescue true
    end
    Rule.add_score_detail(self.account_id, serie_id, self, 'create') rescue true
    Message.create(account_id: self.account_id, receiver_id: self.likeable.account_id, messageable_type: 'Like', messageable_id: self.id) if self.likeable.present?
  
  end

  before_destroy do
    if self.likeable_type == "Answer" && self.liked == false
      dislikes_count = self.likeable.dislikes_count
      self.likeable.update_attribute(:dislikes_count, dislikes_count - 1 )
    end
    if self.likeable_type == "Comment" && self.liked == false
      dislikes_count = self.likeable.dislikes_count
      self.likeable.update_attribute(:dislikes_count, dislikes_count - 1 )
    end
  end

  after_destroy do
    case self.likeable_type 
    when 'Video'
      PersonalId.where(account_id: self.account_id).first.atomic_remove(:like_videos, self.likeable_id) rescue true
    when 'Post'
      PersonalId.where(account_id: self.account_id).first.atomic_remove(:like_posts, self.likeable_id) rescue true
    end
  end

  def with_virtual_attr_for_api
    self.attributes.merge({
      'account' => self.account.with_virtual_attr_for_api,
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc
      })
  end

end
