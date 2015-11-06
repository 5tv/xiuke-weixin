class Node < ActiveRecord::Base
  belongs_to :term
  belongs_to :nodeable, polymorphic: true
  TYPE = {'视频' => 'Video', '平台文章'=>'PlatformArticle', '分镜' => 'Storyboard'}
  include Redis::Search

  redis_search_index(
    :title_field => :nodeable_type,
    :score_field => :display_order,
    :ext_fields => [:id, :nodeable_type, :created_at, :node_content,:front_end_style],
    :class_name => 'Node'
  )

  def node_content
    case self.nodeable_type 
    when "Video"
      @node_content = Video.online.where(id:self.nodeable_id).first
    when "PlatformArticle" || "storyboard"
      @node_content = Article.where(id:self.nodeable_id).first
    end 
  	@node_content.present? ? @node_content.attr_for_search : {:messsage => 'content not found'}
  end

  def video
      @node_content = Video.online.where(id:self.nodeable_id).first
  end

  def platformarticle
      @node_content = Article.where(id:self.nodeable_id).first
  end

  def storyboard
      @node_content = Article.where(id:self.nodeable_id).first
  end

  def attr_for_search
    attrs = Node.redis_search_options.values.flatten
    attrs.pop(6)
    attrs += [:front_end_style]
    attrs += [:nodeable_id]
    attrs += [self.nodeable_type.downcase]
    res = {}
    attrs.each do |attr|
      res.merge!({attr => eval("self.#{attr.to_s}")})
    end
    res
  end

end
