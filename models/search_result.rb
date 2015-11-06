class SearchResult < ActiveRecord::Base

  after_create do
    begin
      content = self.content
      @s = SearchResultStatistic.where(content: content).first
      if @s.present?
        count = @s.count + 1
        @s.update(count: count)
      else
        SearchResultStatistic.create(content: content)
      end
    rescue
      true
    end
  end

  def self.videos_in_redis title,current_account
     @videos=[]
     @series_ids = current_account.related_series_ids
     Redis::Search.query('Video',"#{title}").map{|a| @videos << Video.find(a['id']) if @series_ids.include? Video.find(a['id']).serie.id} rescue []
     @videos
  end

  def self.series_in_redis title,current_account
     @series=[]
     @series_ids = current_account.related_series_ids
     Redis::Search.query('Serie',"#{title}").map{|a| @series << Serie.find(a['id']) if @series_ids.include? Serie.find(a['id']).id} rescue []
     @series
  end

  def self.articles_in_redis title,current_account
     @articles = []
     @series_ids = current_account.related_series_ids
     Redis::Search.query('Article',"#{title}").map{|a| @articles << Article.find(a['id']) if @series_ids.include? Article.find(a['id']).serie_id} rescue []
     @articles
  end

  #TODO:  演职员筛选
  def self.account_series_in_redis title,current_account
     @account_series = []
     (Account.is_manager? current_account)? (@account_series = AccountSerie.order('display_order desc') || []) : (@account_series = AccountSerie.where(:operator_id=>current_account.id).order('display_order asc') || [])
     @account_series.map { |as| 
      @account_series << as if as.account.name.include?(title) || (as.account.email.include?(title) if as.account.email.present?)
      @account_series << as if Account.find(as.operator_id).name.include?(title) rescue [] || (Account.find(as.operator_id).email.include?(title) rescue [] if Account.find(as.operator_id).email.present?)
     }
     @account_series
  end

  def self.posts_in_redis title,current_accoun
    @series_ids = current_account.related_series_ids
    @posts=[]
    Redis::Search.query('Post',"#{title}").map{|a| @posts << Post.find(a['id']) if @series_ids.include? Post.find(a['id']).serie.id  } rescue []
    @posts
  end

  def self.labels_in_redis title,current_account
    (Account.is_manager? current_account) ? (@labels=Redis::Search.query('XlabelList',"#{title}") rescue []) : []
  end

  def self.get_highlight str,key
    "#{(str.include? key)? (str.gsub(key,'<span style=\'color:red\'>'+key+'</span>')) : str}"
  end
    
  private
  def self.get_own_series current_account
    (Account.is_manager? current_account)? (@series = Serie.order('created_at asc') || []) : (@series = current_account.related_series.order('created_at asc') || [])
  end


end 
