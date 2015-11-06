class Post < ActiveRecord::Base
  acts_as_cached
  include Redis::Search
  acts_as_taggable_on :post_tag

  attr_accessor :post_tags
  
  has_many :replies, :as => :replyable, :dependent => :destroy
  has_many :pictures, :as => :pictureable, :dependent => :destroy
  belongs_to :serie
  belongs_to :account
  # has_many :invite_details
  has_many :likes, :as => :likeable, :dependent => :destroy
  has_many :complaints, as: :complaint_for, dependent: :destroy
  has_many :shares, :as => :shareable, :dependent => :destroy
  has_many :mentions, :as => :mentionable, :dependent => :destroy
  has_many :questions, foreign_key: :questionnaire_id

  belongs_to :video
  belongs_to :post_for, :polymorphic => true

  # has_many :invite_accounts, 
  #             :through => :invite_details, 
  #             :foreign_key => :send_to, 
  #             :source => :ask_people

  validates_presence_of  :body, :serie_id, :account_id
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  accepts_nested_attributes_for :questions, :allow_destroy => true
  validates_numericality_of :likes_count, greater_than_or_equal_to: 0
  #用于获得tag显示的背景色
  POST_TAG_COLOUR = {"剧情" => "story", "剧情讨论" => "story",
                     "演员" => "composer", "评论" => "composer",
                     "制作" => "AE", "提问" => "AE", 
                     "剧志" => "blog", "拍摄日志" => "blog",
                     "吐槽" => "none"}

  #表示tag的地方文本更改
  POST_TAG_VIEW = {"剧情" => "剧情讨论", "剧情讨论" => "剧情讨论",
                   "演员" => "评论", "评论" => "评论",
                   "制作" => "提问", "提问" => "提问",
                   "剧志" => "拍摄日志", "拍摄日志" => "拍摄日志",                   
                   "吐槽" => "吐槽"}
  #应对客户端 怪异的需求
  POST_TAG_VIEW_API = { "剧情讨论" => "剧情猜想",
                   "评论" => "评论",
                   "提问" => "提问",
                   "拍摄日志" => "评论",
                   "吐槽" => "吐槽"}

  # if post_tag changed , remember to change PERMISSION config
  POST_TAG = ["剧情", "演员", "制作", "剧志"]
  POST_TAG_DEFAULT = []
  # 0:未处理 1:接受 2:拒绝
  POST_STATUS = { '0' => 'new', '1' => 'accept', '2' => 'reject'}
  # 1:添加邀请 2:取消邀请
  ASKPEOPLE_OP = { "0" => "add", "1" => "remove"}
  POST_TYPE = {"玩剧" => 1, "普通" => 0, '问卷' => 2}
  ONTOP = {"不置顶" => false, "置顶" => true}

  INDEX_PER_PAGE = 4

  POST_FOR_TYPE = ['Serie', 'Video']

  SOURCE = ['微博', '微信', 'android', 'iOS', 'web']

  scope :undeleted, ->{where(deleted: false)}
  scope :toy, ->{where(post_type: POST_TYPE["玩剧"])}
  scope :from_videos, ->(videos) { where(video_id: videos) }
  scope :ontop, ->{where(ontop: true)}

  after_save do
    if post_type_changed?
      if self.serie
        if post_type == POST_TYPE["玩剧"]
          self.serie.update(is_toy: true)
        else
          if self.serie.is_toy == true && self.serie.posts.toy.count == 0
            self.serie.update(is_toy: false)
          end
        end
      end
    end
    if(ontop_changed? || post_type_changed?)
      APP_CACHE.delete("#{CACHE_PREFIX}/series/asc")
      APP_CACHE.delete("#{CACHE_PREFIX}/series/desc")
    end

    if deleted_changed? && self.deleted == true
      if s = self.serie
        s.update_attribute(:posts_count, s.posts_count - 1)
      end

      if temp = self.post_for
        temp.update_attribute(:posts_count, temp.posts_count - 1) if POST_FOR_TYPE.include?(self.post_for_type)
      end
    end

  end
  
  before_create do
    if self.post_for_type == 'Video' && !self.video_id.present?
      self.video_id = self.post_for_id
    elsif self.video_id.present? && !self.post_for_type.present?
      self.post_for_type = 'Video'
      self.post_for_id = self.video_id
    end
  end

  after_create do
    begin
      Rule.add_score_detail(self.account_id, self.serie_id, self, 'create')
      persons = Account.where(name: self.body.mentioned_people).ids if self.body.mentioned_people.present?
      if persons.present?
        persons.each do |person|
          Mention.create(account_id: self.account_id, receiver_id: person, mentionable_type: 'Post', mentionable_id: self.id)
        end
      end
      if POST_FOR_TYPE.include?(self.post_for_type)
        if temp = self.post_for
          temp.update(posts_count: temp.posts_count + 1)
        end
        if s = self.serie
          s.update_attribute(:posts_count, s.posts_count + 1)
        end
      end
    rescue => e
    end
  end

  def post_tag_list_api
    tag_list = []
    self.post_tag_list.each do |tag|
      tag_list << POST_TAG_VIEW_API[POST_TAG_VIEW[tag]]
    end
    tag_list << "吐槽" if self.post_tag_list.size == 0
    return tag_list
  end

  def with_virtual_attr
    self.attributes.merge({
      "serie" => self.serie
    })
  end
  
  def with_virtual_attr_for_api(account_id)
    post_tag = self.post_tag_list_api.join(",")
    questions = self.questions.order('created_at desc').map(&:with_virtual_attr_for_api) rescue []
    temp = self.attributes
    temp.delete('deleted')
    likes = self.likes.order('created_at desc').limit(2)
    pictures = self.pictures.present? ? self.pictures : []
    temp.merge!({
      'cover1' => pictures[0] ? pictures[0].attachment.url : '',
      'cover2' => pictures[1] ? pictures[1].attachment.url : '',
      'cover3' => pictures[2] ? pictures[2].attachment.url : '',
      'cover4' => pictures[3] ? pictures[3].attachment.url : '',
      'cover5' => pictures[4] ? pictures[4].attachment.url : '',
      'cover6' => pictures[5] ? pictures[5].attachment.url : '',
      'cover7' => pictures[6] ? pictures[6].attachment.url : '',
      'cover8' => pictures[7] ? pictures[7].attachment.url : '',
      'cover9' => pictures[8] ? pictures[8].attachment.url : '',
      'tags' => post_tag,
      '_ilike' => Like.where(account_id: account_id, likeable_type: 'Post', likeable_id: self.id).present?, 
      'account' => self.account.with_virtual_attr_for_api,
      '_latest_liker_account' => likes.present? ? likes.map{|like| like.account.with_virtual_attr_for_api} : [],
      'pictures' => self.pictures.present? ? self.pictures.map{|picture| picture.with_virtual_attr_for_api} : [],
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc,
      'questions' => questions
      })
    temp
  end

  def with_virtual_attr_for_api_v2
    post_tag = self.post_tag_list_api.join(",")
    temp = self.attributes
    temp.delete('deleted')
    9.times {|n| temp.delete("cover#{n+1}")}
    likes = self.likes.order('created_at desc').limit(2)
    # pictures = self.pictures.present? ? self.pictures : []
    temp.merge!({
      # 'cover1' => pictures[0] ? pictures[0].attachment.url : '',
      # 'cover2' => pictures[1] ? pictures[1].attachment.url : '',
      # 'cover3' => pictures[2] ? pictures[2].attachment.url : '',
      # 'cover4' => pictures[3] ? pictures[3].attachment.url : '',
      # 'cover5' => pictures[4] ? pictures[4].attachment.url : '',
      # 'cover6' => pictures[5] ? pictures[5].attachment.url : '',
      # 'cover7' => pictures[6] ? pictures[6].attachment.url : '',
      # 'cover8' => pictures[7] ? pictures[7].attachment.url : '',
      # 'cover9' => pictures[8] ? pictures[8].attachment.url : '',
      'tags' => post_tag,
      'account' => self.account.with_virtual_attr_for_api,
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc
      })
    temp
  end


  def liked(account)
    Like.exists?(account_id: account, likeable_id: self.id, likeable_type: 'Post')
  end

  def self.can_create? current_account
    series=current_account.related_series
    series.map{|s|  return true if s.videos.count>0} if series.present?
    return false
  end

  redis_search_index(
    :title_field => :title,
    :alias_field => :body,
    # :prefix_search_enable => true,
    :score_field => :created_at,
    # :condition_fields => [:account_id, :status],
    # :ext_fields => [:description, :serie_title, :duration, :covers],
    :class_name => 'Post'
  )
  def change_ontop
    self.ontop ? self.ontop=false : self.ontop=true 
    self.save 
  end

  def change_post_delete
    self.deleted ? self.deleted=false : self.deleted=true 
    self.save
  end
end
