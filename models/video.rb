class Video < ActiveRecord::Base
  acts_as_cached
  include Redis::Search
  belongs_to :serie
  belongs_to :season
  belongs_to :recommending_video, :class_name => "Video"
  has_many :recommended_videos,  :class_name => "Video", :foreign_key => "recommending_video_id"
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :account_videos, class_name: 'AccountVideo'
  has_many :barrages
  has_many :topics
  belongs_to :operator, class_name: "Account", foreign_key: "operator_id"
  belongs_to :account
  has_many :replies, :as => :replyable, :dependent => :destroy
  has_one :video_transcoding_status
  has_one :video_status
  # has_many :posts, ->{where(deleted: false)}
  has_many :messages, :as => :messageable, :dependent => :destroy
  has_many :sample_details
  has_many :lookers,
                :through => :sample_details, 
                :source => :send_to_account
  has_many :ylabels, as: :ylabelable

  has_many :account_specials, :as => :special_for
  has_many :app_download_infos, dependent: :destroy
  has_one :product, as: :product_for
  has_one :discovery
  has_one :node, as: :nodeable

  has_many :ylabels, :foreign_key => "ylabelable_id"
  attr_accessor :is_has_product

  # attr_accessor :recommendation_title

  # 标签用
  has_many :posts, as: :post_for, :class_name => 'Post', dependent: :destroy
  # 发布视频帖子
  has_many :feed_posts, :as => :post_for, :class_name => "Post"
  has_many :video_effective_share_people
  has_one :candidate, as: :candidate_for, dependent: :destroy
  belongs_to :channel_group
  has_many :articles
  has_many :operation_records, as: :operation_recordable

  mount_uploader :cover, ImageUploader
  mount_uploader :attachment, VideoUploader
  mount_uploader :f360p, VideoUploader
  mount_uploader :f540p, VideoUploader
  mount_uploader :f720p, VideoUploader
  mount_uploader :attachment_s3, VideoUploaderS3
  mount_uploader :f540p_s3, VideoUploaderS3
  mount_uploader :f360p_s3, VideoUploaderS3

  mount_uploader :srt, SrtUploader
  mount_uploader :cover1x1, ImageUploader

  MILESTONE_NUM = [100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 
    1000000, 2000000, 5000000, 10000000, 20000000, 50000000, 100000000, 200000000, 500000000, 1000000000, 2000000000, 5000000000]
  
  STATUS = {
            '新上传'      =>5,#new status
            '等待转码'    =>1,#new status
            '转码中'      =>7,
            '转码失败'    =>3,#new status
            '转码完成'    =>8,#will be deleted using script after refactored 
            '等待审核'    =>9,#new status
            '审核中'      =>12,#new status
            '审核不通过'  =>13,#new status
            '审核通过'    =>14,#new status
            '已上线'      =>10,
            '已下线'      =>11,
            '转码失败'    =>51,
            '视频不规范'  =>52,
            '删除'        =>0
          }

  CHECK_STATUS = {'审核失败' => 0, '审核通过' => 1, '待审核' => 2}
  IS_AUTO_ONLINE = {'随时更新' => 0, '定时更新' => 1}
  WATERMARK_POSITION = {'右上角' => 0, '左上角' => 1}
  WATERMARK_POSITION_EN = {0 => 'right-up', 1 => 'left-up'}
  DEVICE = ['Android', 'iPhone', 'iPad']
  SHARE_SECRET = "fenxiangmiyao2"
  scope :online, -> { where(status: STATUS['已上线'])}
  scope :online_and_coming, -> { where("status = #{STATUS['已上线']}")}
  scope :not_delete, -> { where("status <> #{STATUS['删除']}")}
  scope :transcode_ok, -> { where(["status in (?)",[STATUS['转码完成'],STATUS['已上线'],STATUS['已下线']]])}


=begin
正片[feature]
预告片[preview]
番外篇[special]
选角与报名视频[candidate]
测试样片[sample]
有限范围邀请的测试样片[invite_sample]  
=end
  VIDEO_TYPE = {'正片' => 1, '预告' => 2, '选角' => 3, '测试样片' => 4, '番外' => 5, '有限范围邀请的测试样片' => 6}

  # scope :positive, -> { where(video_type: VIDEO_TYPE['正片']) }
  # scope :sample, -> { where(video_type: VIDEO_TYPE['预告']) }
  # scope :vote, -> { where(video_type: VIDEO_TYPE['选角']) }
  # scope :prev, -> { where(video_type: VIDEO_TYPE['测试样片'])}
  scope :feature, -> { where(video_type: VIDEO_TYPE['正片']) }
  scope :preview, -> { where(video_type: VIDEO_TYPE['预告']) }
  scope :special, -> { where(video_type: VIDEO_TYPE['番外']) }
  scope :candidate, -> { where(video_type: VIDEO_TYPE['选角']) }
  scope :sample, -> { where(video_type: VIDEO_TYPE['测试样片']) }
  scope :invite_sample, -> { where(video_type: VIDEO_TYPE['有限范围邀请的测试样片']) }
  default_scope { where.not(video_type: VIDEO_TYPE['测试样片']) }


  scope :no_need_special, -> { where(is_need_special:false) }
  scope :top_last_week, ->(limit) {
    select("videos.*, count(videos.id) AS watched_count").
    joins(:serie).where("series.status < ?", 2).
    joins(:account_videos).where("account_videos.created_at > ?", Date.today - 7.days).online.feature.
    group("videos.id").
    order("watched_count DESC").
    limit(limit) }
  

  validates_presence_of     :title
  validates_length_of :title, :within => 2..102, :tokenizer => lambda{|s| s.encode('gb18030').bytes }

  before_create do
    self.operator_id = self.account_id
    # self.is_need_special = true if self.serie.is_has_product
  end

  after_create do
    if self.serie.present?
      self.serie.update(latest_video_created_at: self.created_at)
    end
    SerieRelatedId.find_or_create_by(serie_id: self.serie_id).atomic_append(:videos, self.id) rescue true 
  end

  before_save do
    self.serie_title = self.serie.title
    if status_changed?
      if self.status == STATUS['已上线']
        self.last_online_time = Time.now
        self.serie.last_online_video_time = Time.now
        self.serie.online_videos_count = self.serie.online_videos_count +  1
        self.serie.save!
      else

      end
      if self.status == STATUS['删除']
        SerieRelatedId.where(serie_id: self.serie_id).first.atomic_remove(:videos, self.id) rescue true
      end
    end
  end

  before_destroy do
    SerieRelatedId.where(serie_id: self.serie_id).first.atomic_remove(:videos, self.id) rescue true
  end 

  after_update do 
    write_down_operation_record
  end

  after_save do

    ChannelGroup.clear_cached_latest
    
    if status_changed?
      self.update_second_level_cache
      begin 
        if self.status == STATUS['已上线']
          SendEmail.perform_async({'video_id' => self.id, 'type' => 'online_video'}.to_json)
        end

        APP_CACHE.delete('/api/videos/default')
        if self.serie_id.present?
          self.serie.delete_video_ids_cache_key
        end
        if self.status == STATUS['已上线']
          #等待通知重新设计
          #MessagePush.perform_async(self.id)
        end
      rescue
      end

      APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.serie_id}/update_to"
      # APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.serie_id}/videos/asc"
      # APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.serie_id}/videos/desc"
    end
    if self.status == STATUS['已上线']
      if self.serie_id.present?
        key = "#{CACHE_PREFIX}/serie/main_video_id/#{self.serie_id}"
        APP_CACHE.delete(key)
        self.serie.delete_video_ids_cache_key
      end
    end

    if self.check_status_changed?
      if self.check_status == CHECK_STATUS['审核通过']
        self.serie.last_check_video_time = Time.now
        self.serie.save!
      end
    end

    if self.likes_count_changed?
      arr = Video.where(serie_id: self.serie_id).map{|v| v.likes_count.to_i} rescue []
      self.serie.update(video_likes_count: arr.sum)
    end

  end

  after_update do 
    APP_CACHE.delete("#{CACHE_PREFIX}/serie/#{self.serie.id}/videos/asc")
    APP_CACHE.delete("#{CACHE_PREFIX}/serie/#{self.serie.id}/videos/desc")
  end

  after_destroy do
    self.update_second_level_cache
  end

  redis_search_index(
    :title_field => :title,
    :alias_field => :description,
    # :prefix_search_enable => true,
    :score_field => :created_at,
    :condition_fields => [:account_id, :status, :video_type],
    :ext_fields => [:id, :description, :episode, :front_end_style, :serie_title, :duration, :covers, :cover1x1_hash, :serie_id, :posts_count, :url_for_search, :through_posts, :first_serie_account_for_api, :serie_type, :service_type_num, :exclusive],
    :class_name => 'Video'
  )

  # def method_missing(method)
  #   if (/^url_/ =~ method.to_s).present?
  #     method_suffix = method.to_s.split('_')[1]
  #     if AB_TEST
  #       # srand
  #       r = Random.rand(0.0..1.0)
  #       # puts r
  #       if r >= 0.5
  #         method_name = "#{method_suffix}"
  #       else
  #         method_name = "#{method_suffix}_s3"
  #       end
  #       # puts method_name
  #     else
  #       if VIDEO_SOURCE == 'qiniu'
  #         method_name = "#{method_suffix}"
  #       elsif VIDEO_SOURCE == 's3'
  #         method_name = "#{method_suffix}_s3"
  #       end
  #     end
  #     send(method_name).send(:url)
  #   else
  #     fail NoMethodError.new("undefined method '#{method}' for #{self}:#{self.class}", method)
  #   end
  # end

  def attributes_to_be_record
    [
     "serie_id",
     "title",
     "description",
     "episode",
     "cover",
     "attachment_s3",
     "video_type",
     "display_order",
     "is_auto_online",
     "auto_online_time",
     "last_online_time",
     "front_end_style",
     "cover1x1",
     "order_in_group",
     "channel_group_id",
     "recommendation_title"]
  end

  def write_down_operation_record
    attributes_to_be_record.each do |attribute_name|
      if eval("self.#{attribute_name}_changed?")
        operation_record = OperationRecord.new
        operation_record.operation_recordable = self
        operation_record.attribute_name = attribute_name
        operation_record.from_value = eval("self.#{attribute_name}_change.first.to_s")
        operation_record.to_value = eval("self.#{attribute_name}_change.last.to_s")
        operation_record.save!
      end
    end
  end

  def through_posts
    temp_posts = self.posts.undeleted.order('ontop desc, created_at desc')
    temp_posts.order("created_at DESC").first(3).map(&:with_virtual_attr_for_api_v2)
  end

  def url_for_search
    {
      'f540p' => self.get_url,
      'f360p' => self.get_url('360')
    }
  end

  def cover1x1_hash
    {
      origin: self.cover1x1.url,
      x1200: self.cover1x1.x1200.url,
      x1000: self.cover1x1.x1000.url,
      x800: self.cover1x1.x800.url,
      x600: self.cover1x1.x600.url,
      x400: self.cover1x1.x400.url,
      x300: self.cover1x1.x300.url,
      x200: self.cover1x1.x200.url,
      x150: self.cover1x1.x150.url,
      x100: self.cover1x1.x100.url
    }
  end

  def covers
    {
      origin: self.cover.url,
      x1200: self.cover.x1200.url,
      x1000: self.cover.x1000.url,
      x800: self.cover.x800.url,
      x600: self.cover.x600.url,
      x400: self.cover.x400.url,
      x300: self.cover.x300.url,
      x200: self.cover.x200.url,
      x150: self.cover.x150.url,
      x100: self.cover.x100.url
    }
  end

  def covers_changed?
    true
  end

  def with_virtual_attr
    self.attributes.merge({
      "serie" => self.serie,
      "get_url" => self.get_url, 
      "get_cover" => self.get_cover, 
      "cover" => self.get_cover, 
      "size" => self.f540p_filesize,
      'srt' => self.srt.url,
      'episode_or_type' => self.episode_or_type
    })
  end

  # def discovery_template_for_api
  #   self.attributes.merge({
  #     'cover' => self.discovery.present? ? self.discovery.cover.url : self.get_cover,
  #     'covers' => {
  #       x1200: self.cover.x1200.url,
  #       x1000: self.cover.x1000.url,
  #       x800: self.cover.x800.url,
  #       x600: self.cover.x600.url,
  #       x400: self.cover.x400.url,
  #       x300: self.cover.x300.url,
  #       x200: self.cover.x200.url,
  #       x150: self.cover.x150.url,
  #       x100: self.cover.x100.url
  #       },
  #     'serie_title' => self.serie.title,
  #     'title' => self.discovery.present? ? self.discovery.title : self.title
  #     })
  # end

  # 保留 与老app版本保持兼容
  def with_virtual_attr_for_api account
    self.attributes.merge({
      'account' => self.account_id.present? ? self.account.with_virtual_attr_for_api : '',
      'cover' => self.get_cover,
      'covers' =>{
        x1200: self.cover.x1200.url,
        x1000: self.cover.x1000.url,
        x800: self.cover.x800.url,
        x600: self.cover.x600.url,
        x400: self.cover.x400.url,
        x300: self.cover.x300.url,
        x200: self.cover.x200.url,
        x150: self.cover.x150.url,
        x100: self.cover.x100.url
        },
      'cover1x1' => {
        x1200: self.cover1x1.x1200.url,
        x1000: self.cover1x1.x1000.url,
        x800: self.cover1x1.x800.url,
        x600: self.cover1x1.x600.url,
        x400: self.cover1x1.x400.url,
        x300: self.cover1x1.x300.url,
        x200: self.cover1x1.x200.url,
        x150: self.cover1x1.x150.url,
        x100: self.cover1x1.x100.url
        },
      'f540p' => self.get_url,
      'f360p' => self.get_url('360'),
      'srt' => self.srt.url,
      'size' => self.f540p_filesize,
      'can_play_video' => account_video_relation(account),
      'video_share_count' => SCANF_DATA["video_share/#{self.id}/all"] || 0,
      'posts_count' => self.posts.undeleted.count,
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc
      })
  end

  def with_virtual_attr_for_api_v2 
    temp_posts = self.posts.undeleted.order('ontop desc').order('created_at desc')
    self.attributes.merge({
      # 'account' => self.account_id.present? ? self.account.with_virtual_attr_for_api : '',
      'account' => self.first_serie_account.with_virtual_attr_for_api,
      'cover' => self.get_cover,
      'covers' =>{
        x1200: self.cover.x1200.url,
        x1000: self.cover.x1000.url,
        x800: self.cover.x800.url,
        x600: self.cover.x600.url,
        x400: self.cover.x400.url,
        x300: self.cover.x300.url,
        x200: self.cover.x200.url,
        x150: self.cover.x150.url,
        x100: self.cover.x100.url
        },
      'cover1x1' => {
        x1200: self.cover1x1.x1200.url,
        x1000: self.cover1x1.x1000.url,
        x800: self.cover1x1.x800.url,
        x600: self.cover1x1.x600.url,
        x400: self.cover1x1.x400.url,
        x300: self.cover1x1.x300.url,
        x200: self.cover1x1.x200.url,
        x150: self.cover1x1.x150.url,
        x100: self.cover1x1.x100.url
        },
      'f540p' => self.get_url,
      'f360p' => self.get_url('360'),
      'srt' => self.srt.url,
      'size' => self.f540p_filesize,
      'video_share_count' => SCANF_DATA["video_share/#{self.id}/all"].to_i,
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc,
      'serie_title' => self.serie.title,
      'play_type' => self.serie.play_type,
      'serie_description' => self.serie.description,
      'posts_count' => temp_posts.count,
      'posts' => temp_posts.order("created_at DESC").first(3).map(&:with_virtual_attr_for_api_v2),
      "exclusive" => self.serie.is_5tv,
      "service_type" => self.serie.client_show_service_type
      })
  end



  ## 
  # methods used for video redis 
  def account_video_relation(account)
    APP_CACHE.fetch(account_video_key(account)) do
      account.can_play_video?(self)
    end
  end

  def account_video_key(account)
    "#{CACHE_PREFIX}/videos/#{self.id}/#{account.id}/#{Video.cache_version}"
  end

  def delete_account_video(account)
    APP_CACHE.delete account_video_key(account)
  end

  def update_api_account_video_relation(account)
    APP_CACHE.delete("/api/videos/#{self.id}/#{account.id}")
    APP_CACHE.fetch("/api/videos/#{self.id}/#{current_account.id}") do
      self.with_virtual_attr_for_api(current_account)
    end
  end

  ## when videos purchased, using this method
  def update_account_video_relation(account)
    delete_account_video(account)
    account_video_relation(account)
    update_account_video_relation(account)
  end

  #

  def liked(account)
    Like.exists?(account_id: account, likeable_id: self.id, likeable_type: 'Video')
  end

  def episode_or_type
    case VIDEO_TYPE.key(self.video_type)
    when '正片'
      "#{self.title}"
    when '预告'
      '预告片'
    when '选角'
      '选角'
    else
      self.title
    end
  end

  def is_watched?(account)
    if account.present?
      AccountVideo.exists?(video_id: self.id, account_id: account.id)
    else
      false
    end
  end

  def is_last_online?
    self.serie.videos.online.order(episode: :desc).first == self
    
  end
  def uniq_key
    self.attachment.file.basename
  end

  def status_text
    STATUS.key(self.status)
  end

  def get_url_4_video_list(resolution = '540')
    if eval("self.f#{resolution}p")
      full_url = eval("self.f#{resolution}p.url")
    else
      full_url = eval("self.url#{resolution}p")
    end

    if full_url.present?
      file_name = full_url.sub(/\?.*$/,'').sub(/http\:\/\/videostatic\.5tv\.com\//, 'http://xiuke.u.qiniudn.com/')
    end
    if file_name
       Qiniu::Auth.authorize_download_url(file_name)
    else
      ""
    end
  end

  def get_url(resolution = '540')
    full_url = eval("self.f#{resolution}p_s3.url")
    full_url = eval("self.f#{resolution}p.url") unless full_url.present?
    full_url
  end

  def get_cover
    if self.cover.file.present?
      self.cover.url
    else
      ""
    end
  end

  def can_show?
    
  end

  def check_status_text
    CHECK_STATUS.key(self.check_status)
  end

  def online_setting
    if IS_AUTO_ONLINE["定时上线"] == self.is_auto_online
      self.auto_online_time.localtime.strftime("%Y-%m-%d %H:%M:%S")
    else
      IS_AUTO_ONLINE.key(self.is_auto_online)
    end
  end

  #methods used for redis_cache
  def cache_online
    if self.status == Video::STATUS['已上线']
      self
    end
  end

  def share_sign(t)
    video_id = self.id.to_s
    share_token = SHARE_SECRET
    param_array = [t, video_id, share_token]
    sign = Digest::MD5.hexdigest( param_array.join('_'))
    return sign
  end

  def self.top_100(api_version = 'v2')
    APP_CACHE.fetch("api:videos:top_100:#{api_version}") do
      if api_version == 'v2'
        top_last_week(100).where.not(id: 3490).map(&:with_virtual_attr_for_api_v2)
      else
        top_last_week(100).where.not(id: 3490).map(&:attr_for_search)
      end
    end
  end

  def self.top_50_page_title
    API_CACHE.get('api:videos:top50:page_title') || '周播榜'
  end

  def self.top_50_page_title=(value)
    API_CACHE.set('api:videos:top50:page_title', value)
  end

  def delete_video
    self.update_attribute(:status, STATUS['删除'])
  end

  def check_video
    self.check_status(:check_status, CHECK_STATUS['审核通过'])
  end

  def change_status status
    if ['转码完成', '已上线','已下线'].include? status
      self.status=STATUS["#{status}"]
      self.save
    end
  end

  def self.update_channel_group(new_video_ids, channel_group_id, xlabel_list_id)
    new_video_ids.each_with_index do |id, index|
      if v = Video.find(id)
        v.channel_group_id = channel_group_id
        v.order_in_group = index + 1
        v.save!
        unless Ylabel.exists?(xlabel_list_id: xlabel_list_id, ylabelable_type: 'Video', ylabelable_id: id)
          Ylabel.create!(xlabel_list_id: xlabel_list_id, ylabelable_type: 'Video', ylabelable_id: id)
        end
      end
    end
  end

  def self.remove_channel_group(old_video_ids, xlabel_list_id)
    old_video_ids.each do |id|
      if v = Video.find(id)
        v.channel_group_id = 0
        v.order_in_group = 0
        v.save!
        if ylabel = Ylabel.where(xlabel_list_id: xlabel_list_id, ylabelable_type: 'Video', ylabelable_id: id).first
          ylabel.destroy
        end
      end
    end
  end

  def first_serie_account
    if self.serie.present? && account_serie = self.serie.account_series.order(:display_order).first
      account_serie.account
    else
      self.account
    end
  end

  def get_xlabel_list_labels
    self.ylabels.map(&:xlabel_list).map(&:label)
    # self.title
  end

  def get_duration_str
    Time.at(self.duration).strftime("%M'%S''")
  end

  def self.get_duration_str(duration)
    Time.at(duration).strftime("%M'%S''")
  end

  def self.serie_block_from_ids(video_ids = [])
    if videos = Video.where(id: video_ids).order("serie_id desc, episode desc")
      uniq_videos = []
      videos.each {|v| uniq_videos << v if(uniq_videos == [] || uniq_videos.last.serie_id != v.serie_id)}
      uniq_videos.map do |v|
        {:serie_block => {:serie => v.serie.attr_for_search, :videos => v.around_videos.online.map(&:attr_for_search)}}
      end
    else
      []
    end
  end

  def around_videos(range = 2)
    arr = [self.episode]
    range.times do |t|
      i = t + 1
      arr = [(self.episode - i)] << arr << (self.episode + i)
    end
    Video.where(:episode => arr.flatten, :serie_id => self.serie_id)
  end

  def douban_rating
    self.serie.douban_rating
  end

  def attr_for_search
    attrs = Video.redis_search_options.values.flatten
    attrs.pop(2)
    attrs << :douban_rating
    attrs << :recommendation_title
    attrs << :play_count
    res = {}
    attrs.each do |attr|
      res.merge!({attr => eval("self.#{attr.to_s}")})
    end
    res
  end

  def attr_for_search_temp_for_android
    attrs = Video.redis_search_options.values.flatten
    attrs.pop(2)
    attrs
    attrs << :douban_rating
    attrs << :recommendation_title
    attrs << :play_count
    res = {}
    attrs.each do |attr|
      res.merge!({attr => eval("self.#{attr.to_s}")})
    end
    res[:url_for_search] = {
      'f540p' => self.f540p.url,
      'f360p' => self.f360p.url
    }
    res
  end

  def first_serie_account_for_api
    self.first_serie_account.with_virtual_attr_for_api
  end

  def first_serie_account_for_search
    unless self.first_serie_account.nil? 
      account_attr_for_search = account.attr_for_search
    end
    unless self.serie.nil?
      if as = AccountSerie.where(serie_id: self.serie_id, account_id: account.id).first
        account_attr_for_search.merge!({"duty" => as.duty})
      end
    end
    account_attr_for_search
  end

  def serie_type #For API version 2
    unless self.serie.nil?
      Serie::SERVICE_TYPE_NEW.invert[self.serie.service_type_num]
    end
  end
  
  def service_type_num #For API version except 2
    self.serie.present? ? self.serie.service_type_num.to_i : 0
  end

  def exclusive
    self.serie.present? ? self.serie.is_5tv.to_i : 0
  end

  def related_videos
    related_videos         = []
    recommended_videos     = self.recommended_videos.present? ? self.recommended_videos.first(3) : []
    special_videos         = self.serie.special_videos.first(2)
    other_videos_in_serie  = self.serie.videos.present? ? (self.serie.videos - [self]).first(4) : []
    related_videos         = related_videos + recommended_videos
    related_videos         = related_videos + special_videos
    related_videos         = related_videos + other_videos_in_serie
    week_top_20_videos     = Video.top_last_week(20)
    other_videos_from_top  = (week_top_20_videos - related_videos).first(10 - related_videos.compact.count)
    related_videos         = related_videos + other_videos_from_top
  end
end
