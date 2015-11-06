class XlabelList < ActiveRecord::Base
  acts_as_cached
  include Redis::Search

  belongs_to :account
  has_many :channel_groups
  has_many :ylabels

  mount_uploader :cover, ImageUploader
  mount_uploader :big_cover, ImageUploader

  LABEL_TYPE = {'普通标签'=> 1,'情景标签'=> 0}
  
  scope :undeleted, ->{where(deleted: false)}
  scope :channel, ->{where(label_type: LABEL_TYPE['情景标签'])}

  validates_uniqueness_of :label, scope: :label_type
  validates_presence_of :label

  after_update do
    if deleted
      #do stm to delete relationship channel
    end
  end

  def with_virtual_attr_for_api
    self.attributes.merge({
      'cover' => self.covers,
      'big_cover' => self.big_covers,
      'inner_page' => "#{XIUKE_API_PREFIX}/v1/channel_groups?xlabel_list_id=#{self.id}"
      })
  end

  def fetch_series(params = {})
    sorting_type = params[:sorting_type] == 'desc' ? 'desc' : "asc"
    tag = params[:tag]
    APP_CACHE.fetch("#{CACHE_PREFIX}/xlabellist/#{self.id}/series/#{sorting_type}") do
      self.series.online.order("created_at #{sorting_type}").limit(1000).map(&:attr_for_search)
    end
  end

  def get_newest_channel_group_video
    ChannelGroup.where(xlabel_list_id: self.id).last.videos
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

  def big_covers
    {
      origin: self.big_cover.url,
      x1200: self.big_cover.x1200.url,
      x1000: self.big_cover.x1000.url,
      x800: self.big_cover.x800.url,
      x600: self.big_cover.x600.url,
      x400: self.big_cover.x400.url,
      x300: self.big_cover.x300.url,
      x200: self.big_cover.x200.url,
      x150: self.big_cover.x150.url,
      x100: self.big_cover.x100.url
    }
  end

  def videos
    Video.joins(:ylabels).where(ylabels: {xlabel_list_id: self.id, ylabelable_type: 'Video'})
  end

  def series
    Serie.joins(:ylabels).where(ylabels: {xlabel_list_id: self.id, ylabelable_type: 'Serie'})
  end

  def self.create_common_label labels,account,video
    begin
      self.transaction do
          @common_labels = XlabelList.where(:label_type=>XlabelList::LABEL_TYPE['普通标签'],:deleted=>false).order('display_order asc').pluck('label')
          labels=labels.split(',')
          labels.each do |label|
             (@common_labels.include? label) ? need_label=XlabelList.where(:label=>label,:deleted=>false)[0] : need_label=XlabelList.create_xlabel(label,account) 
             Ylabel.create({ylabelable_type: 'Video', ylabelable_id: video.id, xlabel_list_id:need_label.id})
          end
      end
    rescue => e
      false
    end
      true
  end

 def self.create_xlabel label, account
    self.create({:label=>label,:account_id=>account.id,:label_type=>1})
 end

  redis_search_index(
    :title_field => :label,
    # :alias_field => :description,
    # # :prefix_search_enable => true,
    # :score_field => :created_at,
    # :condition_fields => [:account_id, :status],
    # :ext_fields => [:description, :serie_title, :duration, :covers, :serie_id, :posts_count],
    :class_name => 'XlabelList'
  )


end
