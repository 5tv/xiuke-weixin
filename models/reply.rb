class Reply < ActiveRecord::Base
  acts_as_cached

  belongs_to :account
  belongs_to :replyable, :polymorphic => true, :counter_cache => true
  has_many :pictures, :as => :pictureable, :dependent => :destroy
  has_many :comments, -> { where(deleted: false).order "created_at DESC" }, :dependent => :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :complainteds, as: :complaint_for, :class_name => 'Complaint', dependent: :destroy
  has_many :mentions, as: :mentionable, :dependent => :destroy
  has_one :message, :as => :messageable, :dependent => :destroy
  scope :undeleted, ->{where(deleted: false)}
  REPLYABLE_TYPE = ['Topic', 'AccountElection', 'Video', 'Event', 'Election', 'Post']

  

  validates_presence_of :body, :account_id, :replyable_id, :replyable_type

  after_create do
    Rule.add_score_detail(self.account_id, self.replyable.serie_id, self, 'create')
    Message.create(account_id: self.account_id, receiver_id: self.replyable.account_id, messageable_type: 'Reply', messageable_id: self.id) if self.replyable.present?
    persons = Account.where(name: self.body.mentioned_people).ids if self.body.mentioned_people.present?
    if persons.present?
      persons.each do |person|
        Mention.create(account_id: self.account_id, receiver_id: person, mentionable_type: 'Reply', mentionable_id: self.id)
      end
    end
  end

  before_create do 
    self.floor_num = self.replyable.replies.count + 1
  end

  def with_virtual_attr
    self.attributes.merge({account: self.account.with_virtual_attr})
  end

  def liked(account)
    Like.exists?(account_id: account, likeable_id: self.id, likeable_type: 'Post')
  end

  def up_and_down_counts
    return self.likes_count - self.likes.where(liked: false).count
  end

  def with_virtual_attr_for_api
    self.attributes.merge({
      'account' => self.account.with_virtual_attr_for_api,
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc
      })
  end
end
