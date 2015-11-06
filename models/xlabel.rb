class Xlabel < ActiveRecord::Base
  include Redis::Search
  belongs_to :xlabelable, :polymorphic => true
  validates_uniqueness_of :xlabelable_id, scope: [:xlabelable_type]
  XLABELABLE = ['Serie']
  LABEL = [ '音乐', '旅游', '时尚', '逗比', '电视剧神速版', '萌系', '脱口秀', '动漫', '星占', '爱电影', '手机看的剧', '搞笑', '男神', '美女', '求不OUT', '吃货', '体育', '亲子家庭', '访谈', '整蛊', '新奇', '型车', '重口味', '情感', '科技', '财经', '教育', '青春校园', '吃喝玩乐','杂七杂八', '电视剧神速版', '搞笑' ,'女神男神', '手机看的剧', '求不OUT', '吃喝玩乐', '奇闻异事']
  # D_LABEL = ['电视剧神速版', '搞笑' ,'女神男神', '手机看的剧', '求不OUT', '吃喝玩乐', '奇闻异事']
  D_LABEL = ['Get', '神剧院', '拒绝宅']
  SLABEL = []
  redis_search_index(
    :title_field => :xlabelable_type,
    :alias_field => :labels,
    # :prefix_index_enable => true,
    :score_field => :video_time,
    # :score_field => :created_at,
    :condition_fields => [:xlabelable_type, :xlabelable_status],
    :ext_fields => [:labels, :details],
    :class_name => 'Xlabel'
  )
  
  def xlabelable_status
    if self.xlabelable_type == 'Serie'
      self.xlabelable.status
    else
      0
    end
  end

  #搜索使用 勿删
  def xlabelable_status_changed?
    true
  end

  def details_changed?
    true
  end

  def video_time_changed?
    true
  end

  def details
    serie = self.xlabelable
    temp = {}
    temp.merge!(
      'title' => serie.title,
      'id' => serie.id,
      'cover_16x9' => serie.cover_16x9_hash,
      'cover_16x6' => serie.cover_16x6_hash,
      'follows_count'=> serie.follows_count,
      'update_to' => serie.update_to,
      'composers' => serie.composers
    )
    temp
  end

  def video_time
    self.xlabelable.last_online_video_time.to_i
  end

  def with_virtual_attr_for_api
    self.attributes
  end



  # def serie_name
  #   self.xlabelable.title
  # end

end
