class Comment < ActiveRecord::Base
  acts_as_cached
  belongs_to :answer
  belongs_to :account
  belongs_to :reply, :counter_cache => true

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :complainteds, as: :complaint_for, :class_name => 'Complaint', dependent: :destroy
  has_many :mentions, as: :mentionable, dependent: :destroy
  has_one :message, :as => :messageable, :dependent => :destroy
 # validates_presence_of :body, :reply_id, :account_id
  scope :undeleted, ->{where(deleted: false)}

  INDEX_PER_PAGE = 4
 
  after_create do
    Rule.add_score_detail(self.account_id, self.reply.replyable.serie_id, self, 'create')
    Message.create(account_id: self.account_id, receiver_id: self.reply.account_id, messageable_type: 'Comment', messageable_id: self.id) if self.reply.present?
    persons = Account.where(name: self.body.mentioned_people).ids if self.body.mentioned_people.present?
    if persons.present?
      persons.each do |person|
        Mention.create(account_id: self.account_id, receiver_id: person, mentionable_type: 'Comment', mentionable_id: self.id)
      end
    end
  end

  def liked(account)
    Like.exists?(account_id: account, likeable_id: self.id, likeable_type: 'Comment')
  end

  def with_virtual_attr_for_api
    self.attributes.merge({
      'account' => self.account.with_virtual_attr_for_api,
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc
      })
  end

end
