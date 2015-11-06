class Article < ActiveRecord::Base
  include Redis::Search

  belongs_to :serie, :counter_cache => true
  belongs_to :account
  belongs_to :video, :counter_cache => true
  belongs_to :article_platform, :counter_cache => true
  has_one    :node, as: :nodeable
  has_many :posts, as: :post_for, :class_name => 'Post', dependent: :destroy

  mount_uploader :cover, ImageUploader
  mount_uploader :cover9x5, ImageUploader

  ARTICLE_TARGET = {:video_article => '视频文章', :serie_article => '系列文章'}
  ARTICLE_TYPE = {'平台文章' => 0, '分镜图' => 1}

  default_scope { where(article_type: 0) }

  after_save do
    APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.serie_id}/articles/desc"
    APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.serie_id}/articles/asc"
  end

  after_destroy do
    APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.serie_id}/articles/desc"
    APP_CACHE.delete "#{CACHE_PREFIX}/serie/#{self.serie_id}/articles/asc"
  end

  redis_search_index(
    :title_field => :title,
    :score_field => :published_at,
    :ext_fields => [:id,:account_id, :abstract, :serie_id, :serie_title, :content_url, :cover_hash,:cover9x5_hash,:article_platform_id, :published_at, :article_type],
    :class_name => 'Article'
  )

  validates_presence_of     :published_at

  def self.sorted_articles_from_redis(params={})
    sorting_type = params[:sorting_type] == 'desc' ? 'desc' : "asc"
    article_type = params[:article_type] == 1 ? 1 : 0
    APP_CACHE.fetch("#{CACHE_PREFIX}/articles/#{sorting_type}/article_type/#{article_type}") do 
      Article.unscoped.order("published_at #{sorting_type}").limit(1000).select{|a| a.article_type.to_i == article_type}.map(&:attr_for_search)
    end

  end 

  def summary
    self.abstract
  end

  def cover_hash
    {
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

  def cover9x5_hash 
    {
      x1200: self.cover9x5.x1200.url,
      x1000: self.cover9x5.x1000.url,
      x800: self.cover9x5.x800.url,
      x600: self.cover9x5.x600.url,
      x400: self.cover9x5.x400.url,
      x300: self.cover9x5.x300.url,
      x200: self.cover9x5.x200.url,
      x150: self.cover9x5.x150.url,
      x100: self.cover9x5.x100.url        
    }
  end

  def attr_for_search
    attrs = Article.redis_search_options.values.flatten
    attrs.pop(3)
    attrs << :summary
    res = {}
    attrs.each do |attr|
      res.merge!({attr => eval("self.#{attr.to_s}")})
    end
    res
  end

  def serie_title
    self.serie.present? ? self.serie.title : ""
  end

  

end
