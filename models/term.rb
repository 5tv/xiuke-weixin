class Term < ActiveRecord::Base
  has_many :nodes
  belongs_to :account

  STATE = {'下线' => 0,'上线' => 1}

  scope :online, -> { where(state: STATE['上线']) }

  after_save do
    APP_CACHE.delete("#{CACHE_PREFIX}/term/#{self.id}/nodes/asc")
  end

  after_destroy do
    APP_CACHE.delete("#{CACHE_PREFIX}/term/#{self.id}/nodes/asc")
    APP_CACHE.delete("#{CACHE_PREFIX}/term/#{self.id}/all_except_newest_terms")
  end

  def self.cached_terms(params={})
    sorting_type = params[:sorting_type] == 'desc' ? 'desc' : "asc"
    APP_CACHE.fetch("#{CACHE_PREFIX}/terms/#{sorting_type}") do 
      Term.online.order("term_num #{sorting_type}").limit(1000).map(&:attr_for_search)
    end
  end

  def account_name
    Account.where(id:self.account_id).name
  end

  def related_nodes
    result = self.cached_nodes
    result.present? ? result : ['node not found']
  end

  def cache_nodes
    APP_CACHE.write("#{CACHE_PREFIX}/term/#{self.id}/nodes/asc",Node.where(:term_id => self.id).order("display_order asc").limit(1000).map(&:attr_for_search))
  end

  def cached_nodes 
    APP_CACHE.fetch("#{CACHE_PREFIX}/term/#{self.id}/nodes/asc") do 
      Node.where(:term_id => self.id).order("display_order asc").limit(1000).map(&:attr_for_search)
    end
  end

  def all_except_newest_terms
    @latest_terms = Term.cached_terms.last(Term.all.count - 1)
    nodes = []
    @latest_terms.each{|term| term[:related_nodes].each{|node| nodes += [node]}}
    result = []
    grouped_nodes = nodes.group_by{|n| n[:node_content][:serie_id]}
    grouped_nodes = Hash[a.map{|k,v| [k,v]}.first(10)] if grouped_nodes.keys.count > 10
    grouped_nodes.each do |k,v|
      if k.present?
        serie_hash = Serie.where(:id => k).map(&:attr_for_search).first
        serie_hash[:nodes] = v.first(3)
        result += [serie_hash]
      end
    end
    recommended_serie_ids = grouped_nodes.keys
    all_online_serie_ids = Serie.online.pluck(:id)
    rest_of_serie_ids = all_online_serie_ids - recommended_serie_ids

    rest_of_serie_ids.each do |id| 
      active_record_serie = Serie.where(id:id)
      serie_hash = active_record_serie.map(&:attr_for_search).first
      serie_hash[:nodes] = []
      active_record_serie.first.default_recommended_videos_ids.each do |nodeable_id| 
        serie_hash[:nodes] += [{nodeable_type:'Video',display_order:nil,id:nil,created_at:nil,node_content:Video.where(:id => nodeable_id).map(&:attr_for_search),front_end_style:'A'}]
      end
      serie_hash[:nodes] += [{nodeable_type:'PlatformArticle',display_order:nil,id:nil,created_at:nil,node_content:Article.where(:id => active_record_serie.first.default_recommended_article_id).map(&:attr_for_search),front_end_style:'A'}]
      result += [serie_hash]
    end
    result
  end

  def cache_all_except_newest_terms
    APP_CACHE.write("#{CACHE_PREFIX}/term/#{self.id}/all_except_newest_terms",self.all_except_newest_terms)
  end

  def cached_all_except_newest_terms
    APP_CACHE.fetch("#{CACHE_PREFIX}/term/#{self.id}/all_except_newest_terms") do 
      self.all_except_newest_terms
    end
  end

  def attr_for_search
    attrs = [:id, :account_name, :state, :created_at, :related_nodes]
    res = {}
    attrs.each do |attr|
      res.merge!({attr => eval("self.#{attr.to_s}")})
    end
    res
  end
end
