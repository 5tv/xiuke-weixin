#coding: utf-8
class Serie < ActiveRecord::Base
  acts_as_cached
  include Redis::Search
  belongs_to :account
  has_many :videos, :dependent => :destroy
  has_many :seasons, :dependent => :destroy
  has_many :follows, as: :followable, dependent: :destroy
  has_many :account_series, ->{where(deleted: false)}, class_name: "AccountSerie", dependent: :destroy
  accepts_nested_attributes_for :account_series, :allow_destroy => true
  has_many :serie_accounts, :through => :account_series, :source => :account
  has_many :likes, as: :likeable, dependent: :destroy
  belongs_to :operator, class_name: "Account", foreign_key: "operator_id"
  belongs_to :next_end_of_activityable, :polymorphic => true
  has_many :rates
  has_many :posts, ->{where(deleted: false)}
  has_many :questions
  has_many :products
  has_one :income
  has_one :idea
  accepts_nested_attributes_for :idea, :allow_destroy => true
  has_one :product, as: :product_for
  has_many :agreements
  has_many :account_serie_pms, dependent: :destroy
  has_many :pm_accounts, :through => :account_serie_pms,:source => :account
  has_many :refuse_reasons, as: :refuse_for, dependent: :destroy
  has_many :card_codes
  has_many :recommend_logs, as: :recommend_for, dependent: :destroy
  has_many :recommend_settings, as: :setting_for, dependent: :destroy
  has_many :video_effective_share_people
  has_many :candidates
  has_one :xlabel, as: :xlabelable, dependent: :destroy
  accepts_nested_attributes_for :xlabel, :allow_destroy => true
  has_many :ylabels, as: :ylabelable
  has_many :articles

  has_many :serie_platform_qr_stats, dependent: :destroy 
  has_many :platforms, :through => :serie_platform_qr_stats 

  attr_accessor :refuse_reason
  attr_accessor :refuse_account_id
  attr_accessor :accounting_account_id
  attr_accessor :is_auto_recommend

  mount_uploader :cover, ImageUploader
  mount_uploader :cover16x9, ImageUploader
  mount_uploader :cover16x6, ImageUploader
  mount_uploader :cover14x19, ImageUploader
  mount_uploader :label_cover, ImageUploader
  mount_uploader :card_cover, ImageUploader
  mount_uploader :weixin_cover, ImageUploader

  validates_length_of :title, :within => 2..24, :tokenizer => lambda{|s| s.encode('gb18030').bytes }
  validates_presence_of :title, :account_id, :description

  UPDATE_STATE = {
                    '更新中'    => 0,
                    '已完结'    => 2
  }

  STATUS = {  'new'           => 11,
              'to_check'      => 13,# not used
              'checking'      => 4,# not used
              'refuse'        => 5,# not used
              'approved'      => 15,# not used
              'online'        => 1,
              'offline'       => 0,
              'coming_soon'   => 2,# not used
              'deleted'       => 6
           }
           
  STATUS_T = {
              '新创建'         => 11,
              '待审核'         => 13,# not used
              '审核中'         => 4,# not used
              '审核失败'       => 5,# not used
              '审核通过'       => 15,# not used
              '已上线'         => 1,
              '已下线'         => 0,
              '即将上线'       => 2,# not used
              '删除'           => 6
             }

  SERVICE_TYPE = { 
                   '授权类' => 0,
                   '授权改短类' => 1,
                   '联合出品类' => 2,
                   '协同制作类' => 3,
                   '聚合编辑类' => 4,
                   '自制类' => 5
                 }
#业务类型编号  业务类型  前端显示方式  认定要求与说明 审核权限
#11  联合出品  5tv出品 5tv与他人共同参与投资的系列 Admin
#12  独家出品  5tv出品 5tv独立投资的系列  Admin
#21  原创授权  原创  视频画面与原始素材，是由创作者用户所创作拍摄的系列（拿现有素材进行剪辑、再制的不能被视为原创） Admin
#22  协作授权  原创  同原创内容，但5tv参与部分制作方面的协助 Admin
#31  一般内容授权  - 创作者用户拿现有素材进行剪辑、再制、重新配音的创作系列 Admin
#91  聚合编辑  - 创作者用户直接聚合、整理、搬运网络上现有视频的系列 
  SERVICE_TYPE_NEW = {"联合出品" => 11, "独家出品" => 12, "原创授权" => 21, "协作授权" => 22, "改编授权" => 23, "一般内容授权" => 31, "来自搜狐" => 41,"来自优酷" => 42,"来自腾讯" =>43,"来自爱奇艺" => 44,"来自乐视" => 45,"聚合编辑" => 91}
  SERVICE_TYPE_SHOW = {11 => "5tv出品",12 => "5tv出品",21 =>"原创",22 =>"原创",23 => "原创",31 =>"-",41 => "搜狐",42 => "优酷",43 => "腾讯", 44 => "爱奇艺",45 => "乐视", 91 => "-"}
  IS_VIDEO_AUTO_ONLINE = {'随时更新' => 0, '定时更新' => 1}
  VIDEO_ONLINE_MODE = {"每日" => 'day', '每工作日' => 'business_day', '每周' => 'week', '每双周' => 'double_week', '每月' => 'month'}
  VIDEO_ONLINE_MODE_VIEW = {"每天" => 'day', '工作日（一 二 三 四 五）' => 'business_day', '每周' => 'week', '每隔2周' => 'double_week', '每隔1个月' => 'month'}
  DAYS_INTO_WEEK_ZHCN = {"周一" => 1, "周二" => 2, "周三" => 3, "周四" => 4, "周五" => 5, "周六" => 6, "周日" => 0}
  DAYS_INTO_WEEK_ZHCN_SAMPLE = {"一" => 1, "二" => 2, "三" => 3, "四" => 4, "五" => 5, "六" => 6, "日" => 0}
  IS_SET_VIDEO_AUTO_ONLINE = {"未设置" => 0, "已设置" => 1}
  IS_5TV = {"非5tv" => 0, "5tv独家" => 1}
  PLAY_TYPE = {"正播" => 0, "倒播" => 1}
  PLAY_TYPE_V = {"从第一集播" => 0, "从最新集播" => 1}
  CREATOR_DUTY = "制片人"
  RECOMMENDED = {"不推荐" => 0, "推荐" => 1}
  TYPE_ON_UI = {'5tv出品' =>1, '原创剧' => 5, '电视浓缩剧' =>15, '平台剧' => 20}
  # 在列表中是否显示
  SHOW_TYPE = {"显示" => 0, "隐藏" => 1}

  # 新用户注册的时候，是否默认追
  FOLLOW_TYPE = {"非默认追" => 0, "默认追" => 1}

  default_scope { order("recommended DESC, recommend_order ASC, created_at DESC") }
  
  scope :online, -> { where(status: STATUS['online']) }
  scope :coming_soon, -> { where(status: STATUS['coming_soon']) }
  scope :online_and_coming, -> { where("status = #{STATUS['online']} or status = #{STATUS['coming_soon']}")}
  scope :online_and_coming_offline, -> { where("status = #{STATUS['online']} or status = #{STATUS['coming_soon']} or status = #{STATUS['offline']}")}
  scope :top_bbs, -> { where(status: STATUS['top_bbs']) }
  scope :has_product, -> { where(is_has_product: true)}
  scope :shown, -> { where(show_type: SHOW_TYPE['显示'])}
  scope :hide, -> { where(show_type: SHOW_TYPE['隐藏'])}
  scope :recommended, -> { where(recommended: RECOMMENDED['推荐'])}

  scope :default_follow, -> { where( follow_type: FOLLOW_TYPE['默认追'])}

  before_create do
    self.default_online_setting
    self.operator_id = self.account_id
  end
  
  after_create do
    Income.create(account_id: self.account_id, serie_id: self.id, money: 0)
    cache_delete
    # api series url index
  end

  before_save do
    begin
      if recommendation_changed?
        if self.recommended == RECOMMENDED['推荐'] 
          if self.recommendation_count == 0
            self.follows_count = self.follows_count + rand(200..2000)
            self.recommendation_count = self.recommendation_count + 1
          else
            self.recommendation_count = self.recommendation_count + 1
          end
        end
      end
    rescue
      true
    end
  end

  after_save do

    ChannelGroup.clear_cached_latest

    if self.video_online_mode == Serie::VIDEO_ONLINE_MODE["每周"]
      raise "no week day" if self.video_online_week_day.size <= 0
      cache_delete
    end

    if status_changed?
      self.account_series.update_all( :series_status => self.status )

      if self.status == STATUS['refuse']
        refuse_reason = self.refuse_reasons.new
        refuse_reason.reason = self.refuse_reason
        refuse_reason.account_id = self.refuse_account_id
        refuse_reason.save!
      end

      if self.status == STATUS_T['已上线']
        self.videos.each do |v|
          v.update(status: Video::STATUS['已上线']) if v.status == Video::STATUS['已下线']
        end
      end
      if self.status == STATUS_T['已下线']
        self.videos.each do |v|
          v.update(status: Video::STATUS['已下线']) if v.status == Video::STATUS['已上线']
        end
      end
      cache_delete
    end

    if latest_video_created_at_changed?
      ids = Serie.online.order('latest_video_created_at desc').limit(10).ids
      Configure.last_or_new.update(latest_video_updated_series: ids.to_s)
    end

    if is_has_product_changed? && self.is_has_product == true
      self.videos.update_all( is_need_special:true )
    end

    if is_has_product_changed? && self.is_has_product == false
      self.videos.update_all( is_need_special:false )
    end 

    if recommended_changed?
      generate_recommend_log(accounting_account_id)
      cache_delete
    end

    if title_changed?
      self.videos.update_all(:serie_title => self.title )
      cache_delete
    end
    self.update_second_level_cache
  end

  after_destroy do
    cache_delete
    
  end

  redis_search_index(
    :title_field => :title,
    :alias_field => :description,
    :condition_fields => [:account_id, :status],
    :ext_fields => [:id,:description, :composers, :follows_count, :recommended_videos, :articles_count, :through_articles, :cover_16x9_hash, :cover_14x19_hash, :cover_16x6_hash, :update_to, :service_type_num, :exclusive, :type_on_ui],
    :class_name => 'Serie'
  )

  def cache_delete
    APP_CACHE.delete("#{CACHE_PREFIX}/series/asc")
    APP_CACHE.delete("#{CACHE_PREFIX}/series/desc")
    APP_CACHE.delete("#{CACHE_PREFIX}/serie/#{self.id}/videos/asc")
    APP_CACHE.delete("#{CACHE_PREFIX}/serie/#{self.id}/videos/desc")
    APP_CACHE.delete("#{CACHE_PREFIX}/serie/#{self.id}/articles/asc/article_type/0")
    APP_CACHE.delete("#{CACHE_PREFIX}/serie/#{self.id}/articles/asc/article_type/1")
    APP_CACHE.delete("#{CACHE_PREFIX}/serie/#{self.id}/articles/desc/article_type/0")
    APP_CACHE.delete("#{CACHE_PREFIX}/serie/#{self.id}/articles/desc/article_type/1")

    APP_CACHE.delete("#{CACHE_PREFIX}/series/newest_series")

    self.update_second_level_cache
    API_CACHE.hmset('apicache/series', self.id, self.with_virtual_attr_for_api.to_json)
    if self.status == STATUS['offline']
      keys=Redis::Search.config.redis.keys('*tmpinterstore*')
      Redis::Search.config.redis.del(*keys) if keys.present?
    end
  end

  def through_articles
    self.articles.order(published_at: :desc).first(1).map(&:attr_for_search)
  end
  
  def self.sorted_series_from_redis(params={})
    sorting_type = params[:sorting_type] == 'asc' ? 'asc' : "desc"
    APP_CACHE.fetch("#{CACHE_PREFIX}/series/#{sorting_type}") do 
      Serie.unscoped.online.order("created_at #{sorting_type}").limit(1000).map(&:attr_for_search)
    end
  end 

  def self.recommended_by_video(count = 20)
    Video.top_last_week(count).map(&:serie).uniq
  end

  def composers
    self.account_series.order('display_order asc').all.select{|as| as.duty != "platform"}.map do |as|
      account = as.account
      {account_id: account.id, profile_image_url_hash: account.profile_image_url_hash, name: account.name, duty: account.duty_in_serie(self.id), display_order: as.display_order}
    end rescue []
  end

  # 搜索更新会用的方法，勿删
  def composers_changed?
    true
  end

  def cover_16x9_hash_changed?
    true
  end

  def cover_16x6_hash_changed?
    true
  end

  def update_to_changed?
    true
  end
  #

  def generate_recommend_log(operator_id)
    recommend_log = RecommendLog.new
    recommend_log.recommend_for = self
    recommend_log.action_type = self.recommended
    recommend_log.happen_time = Time.now
    recommend_log.operator_id = operator_id
    recommend_log.save!
  end

  def status_text
    STATUS_T.key(self.status)
  end

  def with_virtual_attr
    self.attributes.merge({
          cover: self.get_cover, 
          label_cover: self.label_cover,
          card_cover: self.card_cover,
          account_series: self.account_series.order("display_order ASC").map {
            |as| as.attributes.merge({account: as.account})
          },
          update_to_episode: self.last_episode,
          update_to: self.update_to,
          weixin_cover: self.weixin_cover.url
        })
  end

  def with_virtual_attr_for_search
    self.attributes.merge(
      'cover_16x9' => self.cover_16x9_hash,
      'cover_16x6' => self.cover_16x6_hash,
      'composers' => self.composers
    )
  end

  def cover_16x9_hash
    {
      x1200: self.cover16x9.x1200.url,
      x1000: self.cover16x9.x1000.url,
      x800: self.cover16x9.x800.url,
      x600: self.cover16x9.x600.url,
      x400: self.cover16x9.x400.url,
      x300: self.cover16x9.x300.url,
      x200: self.cover16x9.x200.url,
      x150: self.cover16x9.x150.url,
      x100: self.cover16x9.x100.url
    }
  end

  def cover_16x6_hash
    {
      x1200: self.cover16x6.x1200.url,
      x1000: self.cover16x6.x1000.url,
      x800: self.cover16x6.x800.url,
      x600: self.cover16x6.x600.url,
      x400: self.cover16x6.x400.url,
      x300: self.cover16x6.x300.url,
      x200: self.cover16x6.x200.url,
      x150: self.cover16x6.x150.url,
      x100: self.cover16x6.x100.url        
    }
  end

  def cover_14x19_hash
    {
      x1200: self.cover14x19.x1200.url,
      x1000: self.cover14x19.x1000.url,
      x800: self.cover14x19.x800.url,
      x600: self.cover14x19.x600.url,
      x400: self.cover14x19.x400.url,
      x300: self.cover14x19.x300.url,
      x200: self.cover14x19.x200.url,
      x150: self.cover14x19.x150.url,
      x100: self.cover14x19.x100.url    
    }
  end
  
  def with_virtual_attr_for_api
    self.attributes.merge({
      'account' => self.account.with_virtual_attr_for_api,
      # '_likes_count' => self.cache_content_of('videos').map(&:likes_count).sum(&:to_i),
      '_likes_count' => self.video_likes_count,
      '_posts_count' => self.posts_count,
      # '_posts_count' => self.cache_content_of('posts').size,
      'cover' => self.get_cover,
      '_cover_16x9_1200' => self.cover16x9.x1200.url,
      'cover_16x9' => {
        x1200: self.cover16x9.x1200.url,
        x1000: self.cover16x9.x1000.url,
        x800: self.cover16x9.x800.url,
        x600: self.cover16x9.x600.url,
        x400: self.cover16x9.x400.url,
        x300: self.cover16x9.x300.url,
        x200: self.cover16x9.x200.url,
        x150: self.cover16x9.x150.url,
        x100: self.cover16x9.x100.url
        },
      '_cover_16x6_1200' => self.cover16x6.x1200.url,
      'cover_16x6' => {
        x1200: self.cover16x6.x1200.url,
        x1000: self.cover16x6.x1000.url,
        x800: self.cover16x6.x800.url,
        x600: self.cover16x6.x600.url,
        x400: self.cover16x6.x400.url,
        x300: self.cover16x6.x300.url,
        x200: self.cover16x6.x200.url,
        x150: self.cover16x6.x150.url,
        x100: self.cover16x6.x100.url        
        },
      'label_cover' => self.label_cover.url,
      'card_cover' => self.card_cover.url,
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc,
      'articles' => self.articles.order(published_at: :desc).first(1).map(&:attr_for_search)
    })
  end

  def through_posts(account_id)
    self.posts.toy.ontop.order("created_at DESC").first(2).map { |post| post.with_virtual_attr_for_api(account_id) }
  end

  def self.api_merge(id, account)
    test = Serie.find(id)
    {
      'unread_messages_of_video' => 0,
      'through_posts' =>[],
      'update_to_episode' => test.last_episode,
      'update_to' => test.update_to,
      'serie_performers_info' => "",
      'serie_performers_info_detail' => test.serie_performers_info,
      'video_online_setting_text' => test.video_online_setting_day,
      'recommended_videos' => test.recommended_videos_old(account),
      'serie_share_count' => SCANF_DATA["serie_share/#{test.id}/all"],
      'articles' => test.articles.order(published_at: :desc).first(1).map(&:attr_for_search)
    }
  end
  
  def self.combine_data(ids, account)
    tmp_data = {}
    ids.each do |id|
      tmp_data[id] = api_merge(id,account)
    end
    base_data = API_CACHE.hmget('apicache/series', *ids)
    base_data = base_data.map do |data|
      t = JSON.parse(data)
      t.merge!(tmp_data[t['id']])
    end
    base_data
  end

  def self.api_cache_present?
    API_CACHE.exists 'apicache/series'
  end

  def self.api_cache_init
    temp={}
    Serie.all.each do |s|
      temp[s.id] = s.with_virtual_attr_for_api.to_json
    end
    API_CACHE.hmset('apicache/series', *temp)
  end

  def recommended_videos
    self.cache_videos_default.first(2).map(&:attr_for_search)
  end

  def recommended_videos_old(account)
    self.cache_videos_default.map{|a| a if a.is_need_special == false}.first(2).map{|video| video.with_virtual_attr_for_api(account)} rescue []
  end

  def through_posts_for_web
    self.posts.toy.ontop.order("created_at DESC").first(2)
  end

  def unread_messages_of_video(account)
    @follow=Follow.where(account_id: account.id, followable_type: 'Serie' ,followable_id: self.id).first
    if @follow.present?
      this = self.videos.online.map(&:episode).max
      temp = this.to_i - last
      temp >= 0 ? temp : 0
    else
      0
    end
  end
  ##
  # used for redis cache
  def ids_cache_key(relation)
    "#{CACHE_PREFIX}/serie/#{self.id}/#{relation}/ids"
  end

  def fetch_videos(params = {})
    sorting_type = params[:sorting_type] == 'desc' ? 'desc' : "asc"
    APP_CACHE.fetch("#{CACHE_PREFIX}/serie/#{self.id}/videos/#{sorting_type}") do
      self.videos.online.order("episode #{sorting_type}").limit(1000).map(&:attr_for_search)
    end
  end

  def fetch_articles(params = {})
    sorting_type = params[:sorting_type] == 'asc' ? 'asc' : "desc"
    article_type = params[:article_type] == 1 ? 1 : 0
    APP_CACHE.fetch("#{CACHE_PREFIX}/serie/#{self.id}/articles/#{sorting_type}/article_type/#{article_type}") do
      self.articles.order("published_at #{sorting_type}").limit(1000).select{|a| a.article_type.to_i == article_type}.map(&:attr_for_search)
    end
  end

  def ids_cache_content(relation)
    APP_CACHE.fetch(ids_cache_key(relation)) do
      if relation.camelize.singularize == "Post"
        relation.camelize.singularize.constantize.where(serie_id: self.id, is_feed:false, deleted: false).order('created_at desc').ids
      else
        relation.camelize.singularize.constantize.where(serie_id: self.id).order('created_at desc').ids
      end
    end
  end

  def cache_content_of(relation)
    ids_cache_content(relation).map do |id|
      relation.camelize.singularize.constantize.find(id)
    end.compact
  end

  def delete_video_ids_cache_key
    APP_CACHE.delete ids_cache_key('videos')
    APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.id}/videos/positive_ids"
    APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.id}/videos/negative_ids"
  end

  def cache_videos(default='asc')
    key1 = "#{CACHE_PREFIX}/serie/#{self.id}/videos/positive_ids"
    key2 = "#{CACHE_PREFIX}/serie/#{self.id}/videos/negative_ids"
    ids1 = APP_CACHE.fetch(key1) do
      Video.online.where(serie_id: self.id).order('episode asc').ids
    end
    ids2 = APP_CACHE.fetch(key2) do
      Video.online.where(serie_id: self.id).order('episode desc').ids
    end

    if default == 'desc'
      ids2.map{|id| Video.find(id)}.compact
    else
      ids1.map{|id| Video.find(id)}.compact
    end
  end

  def cache_videos_default
    self.play_type == PLAY_TYPE['正播'] ? cache_videos('asc') : cache_videos('desc')
  end

  def serie_performers_info
    APP_CACHE.fetch("series/#{self.id}/performers_info") do
      if self.cache_content_of('account_serie').present?
        @account_series_total = (self.cache_content_of('account_serie').sort{|a,b| a.display_order <=> b.display_order}).map(&:with_base_account_info)
      else
        ''
      end
    end
  end

  def update_to
    key = "#{CACHE_PREFIX}/serie/#{self.id}/update_to"
    update_to_content = APP_CACHE.fetch(key) do
      if self.finished == UPDATE_STATE['已完结']
        '已完结'
      elsif last = self.online_feature_videos.sort{|x,y| y.episode <=> x.episode}.first
        "更新至第#{last.episode}集"
      elsif prev = self.online_preview_videos.last
        prev.title
      else
        '即将上线'
      end
    end
    update_to_content
  end

  def next_episode
    if last = self.online_feature_videos.sort{|x,y| y.episode <=> x.episode}.first 
      "第#{last.episode + 1}集"
    elsif prev = self.online_preview_videos.last
      "第1集"
    else
      '预告片'
    end
  end

  def last_episode
    APP_CACHE.fetch("series/#{self.id}/last_episode") do
      if last = self.online_feature_videos.sort{|x,y| y.episode <=> x.episode}.first 
        last.episode
      else
        0
      end
    end
  end

  def online_feature_videos
    cache_content_of('videos').map{|v| v if v.status == Video::STATUS['已上线'] && v.video_type == Video::VIDEO_TYPE['正片']}.compact.sort{|x,y| y.episode <=> x.episode}
  end

  def online_preview_videos
    cache_content_of('videos').map{|v| v if v.status == Video::STATUS['已上线'] && v.video_type == Video::VIDEO_TYPE['预告']}.compact.sort{|x,y| y.episode <=> x.episode}
  end

  def special_videos
    cache_content_of('videos').map{|v| v if v.status == Video::STATUS['已上线'] && v.video_type == Video::VIDEO_TYPE['番外']}.compact.sort{|x,y| y.episode <=> x.episode}
  end

  def last_video
    self.videos.online.no_need_special.order(episode: :desc).first
  end

  def theme_list
    self.videos.online.no_need_special.order(episode: :desc).first
  end

  def like_count
    online_videos = self.videos.reject{|v| v.status != Video::STATUS["已上线"]}

    like_count = 0

    online_videos.each do |video|
      like_count += video.likes_count
    end
    return like_count
  end

  def set_pm(account_serie_pms_params)
    ActiveRecord::Base.transaction do
      account_serie_pms_data = account_serie_pms_params
      old_account_serie_pm_ids = self.account_serie_pms.collect{|v| v.id.to_s}
      new_account_serie_pm_ids = account_serie_pms_data.collect{|v| v[:id].to_s}

      (old_account_serie_pm_ids - new_account_serie_pm_ids).each do |delete_account_serie_pm_ids|
        AccountSeriePm.find(delete_account_serie_pm_ids).delete
      end
      
      account_serie_pms_data.each do |aspd|
        if aspd[:id].blank?
          account_serie_pm = self.account_serie_pms.new(aspd)
          account_serie_pm.save!
        else
          account_serie_pm = self.account_serie_pms.find(aspd[:id])
          account_serie_pm.account_id = aspd[:account_id]
          account_serie_pm.save!
        end
      end
    end
  end

  def get_cover
    if self.cover.file.present?
      self.cover.url
    else
      ""
    end
  end

  def send_create_mail
    admin_account = Account.where(role_num:[Account::EN_ROLE["xiuker"],Account::EN_ROLE["admin"]])
    emails = admin_account.collect{|v| v.email}
    emails.each do |email|
      EmailSender.serie_create_mail(email,self)
    end
  end

  def service_type
    Serie::SERVICE_TYPE_NEW.key(self.service_type_num) if self.has_attribute?('service_type_num')
  end

  def client_show_service_type
    if self.has_attribute?('service_type_num')
      if(self.service_type_num < 13 and self.service_type_num > 5)
        return "5tv出品"
      elsif(self.service_type_num < 23)
        return "原创"
      end
      return ""
    end
  end

  def next_online_time
    if self.video_online_time
      return next_online_day.beginning_of_day() + (self.video_online_time.localtime - self.video_online_time.localtime.beginning_of_day())
    else
      return next_online_day.beginning_of_day()
    end
  end

  def next_online_day
    if self.is_video_auto_online == IS_VIDEO_AUTO_ONLINE["定时上线"]
      videos = self.videos
      if videos.size > 0 
        last_video = self.videos.where(is_auto_online:Video::IS_AUTO_ONLINE["定时上线"]).order("auto_online_time DESC").first
        last_time = (last_video.present? && last_video.auto_online_time.present?) ? last_video.auto_online_time.localtime : Time.now
      else
        last_time = Time.now
      end
      case self.video_online_mode
      when VIDEO_ONLINE_MODE["每日"]
        next_online_day = last_time + 1.day
      when VIDEO_ONLINE_MODE["每工作日"]
        next_online_day = next_current_day(last_time)
      when VIDEO_ONLINE_MODE["每周"]
        next_online_day = next_current_day(last_time)
      when VIDEO_ONLINE_MODE["每双周"]
        next_online_day = last_time + 2.weeks
      when VIDEO_ONLINE_MODE["每月"]
        next_online_day = last_time + 1.month
      else
        next_online_day = Time.now
      end
      return next_online_day.to_date
    else
      return Time.now.to_date
    end
  end

  def next_current_day(last_time)
    next_day = last_time + 1.day
    while (!self.video_online_week_day_arr.include?(next_day.wday % 7)) do
      next_day = next_day + 1.day
    end   
    return next_day
  end

  def video_online_setting_day
    setting_content = ""
    if self.is_video_auto_online == IS_VIDEO_AUTO_ONLINE["定时上线"] 
      case self.video_online_mode
      when VIDEO_ONLINE_MODE["每周"]
        setting_content += (VIDEO_ONLINE_MODE_VIEW.key(self.video_online_mode))
        setting_content += "(" + self.video_online_week_day.split(",").collect{|v| Serie::DAYS_INTO_WEEK_ZHCN_SAMPLE.key(v.to_i) }.join(",") + ")"
      else
        setting_content += VIDEO_ONLINE_MODE_VIEW.key(self.video_online_mode)
      end
    end
    return setting_content
  end

  def video_online_setting
    setting_content = ""
    if self.is_video_auto_online == IS_VIDEO_AUTO_ONLINE["定时上线"] 
      case self.video_online_mode
      when VIDEO_ONLINE_MODE["每周"]
        setting_content += (VIDEO_ONLINE_MODE_VIEW.key(self.video_online_mode) + "  ")
        setting_content += "(" + self.video_online_week_day.split(",").collect{|v| Serie::DAYS_INTO_WEEK_ZHCN.key(v.to_i) }.join(",") + ")"
      else
        setting_content += VIDEO_ONLINE_MODE_VIEW.key(self.video_online_mode)
      end
      setting_content += "  上线时间：#{self.video_online_time.localtime.strftime("%H:%M")}"
    else
      setting_content = IS_VIDEO_AUTO_ONLINE.key(self.is_video_auto_online)
    end
  end

  def online_setting_text
    setting_content = ""
    if self.is_video_auto_online == IS_VIDEO_AUTO_ONLINE["定时上线"] 
      case self.video_online_mode
      when VIDEO_ONLINE_MODE["每周"]
        setting_content += (VIDEO_ONLINE_MODE_VIEW.key(self.video_online_mode) + "  ")
        setting_content += "(" + self.video_online_week_day.split(",").collect{|v| Serie::DAYS_INTO_WEEK_ZHCN_SAMPLE.key(v.to_i) }.join(",") + ")"
      else
        setting_content += VIDEO_ONLINE_MODE_VIEW.key(self.video_online_mode)
      end
      setting_content = setting_content +"更新" 
    else
      setting_content = ""
    end
    return setting_content
  end
  
  def video_online_week_day_arr
    self.video_online_week_day.split(",").collect{|v| v.to_i}
  end

  def default_online_setting
    
    self.is_set_video_auto_online ||= IS_SET_VIDEO_AUTO_ONLINE["已设置"]
    self.is_video_auto_online ||= IS_VIDEO_AUTO_ONLINE["定时上线"]
    self.video_online_mode ||= VIDEO_ONLINE_MODE["每周"]
    self.video_online_week_day ||= Random.rand(6).to_s
    self.video_online_time ||= Time.now.beginning_of_day() + (Random.rand(12) + 8).hours

  end

  def set_normal(serie_data)
    self.is_5tv = serie_data[:is_5tv]
    self.play_type = serie_data[:play_type]
    self.description = serie_data[:description]
  end

  def set_recommend_settig(recommend_settings_data)
    if recommend_settings_data.present? && recommend_settings_data.size > 0
      ActiveRecord::Base.transaction do
        recommend_settings_data = recommend_settings_data.values
        old_recommend_setting_ids = self.recommend_settings.collect{|v| v.id.to_s}
        new_recommend_setting_ids = recommend_settings_data.collect{|v| v[:id].to_s}

        (old_recommend_setting_ids - new_recommend_setting_ids).each do |delete_recommend_setting_id|
          # ProductItem.find(delete_product_item_id).update_attribute(:status, "delete")
          RecommendSetting.find(delete_recommend_setting_id).delete
        end

        recommend_settings_data.each do |cid|
          if cid[:id].blank?
            recommend_setting = self.recommend_settings.new(cid)
            recommend_setting.action_time = cid[:action_time].to_time
            recommend_setting.action_type = cid[:action_type]
            recommend_setting.operator_id = cid[:accounting_account_id]
            recommend_setting.save!
          else
            recommend_setting = self.recommend_settings.find(cid[:id])
            recommend_setting.action_time = cid[:action_time].to_time
            recommend_setting.action_type = cid[:action_type]
            recommend_setting.operator_id = cid[:accounting_account_id]
            recommend_setting.save!
          end
        end
      end
    end
  end

  def transcode_ok_videos
    online_videos = self.videos.reject{|v| ![Video::STATUS['转码完成'],Video::STATUS['已上线'],Video::STATUS['已下线']].include?(v.status) }
    return online_videos
  end

  def self.recommended_video
    series = Serie.online.where(recommended:Serie::RECOMMENDED['推荐'])
    return nil if series.size <= 0
    serie = series[Random.rand(series.size)]
    video = serie.videos.online.feature.first
    video
  end

  def is_video_online_in_this_day(this_day) 
    case self.video_online_mode
    when VIDEO_ONLINE_MODE_VIEW["每天"]
      return true
    when VIDEO_ONLINE_MODE_VIEW["每工作日"]
      return self.video_online_week_day.split(",").include?(this_day.wday.to_s)
    when VIDEO_ONLINE_MODE_VIEW["每周"]
      return self.video_online_week_day.split(",").include?(this_day.wday.to_s)
    when VIDEO_ONLINE_MODE_VIEW["每双周"] 
      return self.next_online_day.wday == this_day.wday &&  ((self.next_online_day - this_day)%14 == 0)
    else
      return false
    # when VIDEO_ONLINE_MODE_VIEW["每月"]

    end
      #
  end

  def total_video_like
    total_like_count = 0
    videos = self.videos
    videos.each{|v| total_like_count += v.likes_count}
    return total_like_count
  end

  def cache_main_video_id
    key = "#{CACHE_PREFIX}/serie/main_video_id/#{self.id}"
    video_id = APP_CACHE.fetch(key) do
      return 0 if Video.online.where(serie_id: self.id).size == 0
      if self.play_type == PLAY_TYPE['正播']
        Video.online.where(serie_id: self.id).order('episode asc').first.id
      else
        Video.online.where(serie_id: self.id).order('episode desc').first.id
      end
    end
  end

  def self.serie_block_from_ids(serie_ids = [])
    if series = Serie.where(id: serie_ids)
      series.map do |s|
        {:serie_block => {:serie => s.attr_for_search, :videos => s.videos.online.order(episode: :desc).limit(5).map(&:attr_for_search)}}
      end
    else
      []
    end
  end

  def attr_for_search
    attrs = Serie.redis_search_options.values.flatten
    attrs.pop(4)
    attrs << :douban_rating
    attrs << :finished
    res = {}
    attrs.each do |attr|
      res.merge!({attr => eval("self.#{attr.to_s}")})
    end
    res
  end
  # TYPE_ON_UI = {'5tv出品' =>1, '原创剧' => 5, '电视浓缩剧' =>15, '平台剧' => 20}
  def type_on_ui
    if self.concentrated.to_i == 1
      Serie::TYPE_ON_UI['电视浓缩剧']
    elsif self.concentrated.to_i == 0
      if [11,12].include?(self.service_type_num)
        Serie::TYPE_ON_UI['5tv出品']
      elsif [21,22,23].include?(self.service_type_num)
        Serie::TYPE_ON_UI['原创剧']
      else
        Serie::TYPE_ON_UI['平台剧']
      end
    else
      0
    end
  end

  def exclusive
    self.is_5tv ? self.is_5tv : 0 
  end

  def default_recommended_videos_ids
    video1 = self.videos.order("play_count desc").first
    video2 = self.videos.order("play_count desc").first(2).last
    [video1.present? ? video1.id : nil,video2.present? ? video2.id : nil]
  end

  def default_recommended_article_id
    article = self.articles.order("created_at desc").first
    article.present? ? article.id : nil
  end

  def labels 
    self.ylabels.map(&:xlabel_list).map(&:label)
  end

  def newest_episode
    self.videos.present? ? self.videos.map(&:episode).max : 0
  end


  def has_at_least_one_approved_video
    self.videos.each do |v|
      return true if v.status == Video::STATUS['已上线'] or v.status == Video::STATUS['审核通过'] or v.status == Video::STATUS['已下线']
    end 
    false
  end

end
