class Configure < ActiveRecord::Base

  def self.last_or_new
    if Configure.last.present?
      Configure.last
    else
      Configure.create()
    end
  end

  def with_virtual_attr_for_api
    temp = {}
    arr = self.latest_video_updated_series
    arr = JSON.parse(arr)
    arr = arr.join(',')
    temp.merge!({
      'latest_video_updated_series' => arr,
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc
      })
    temp
  end

  def self.app_conf
    {
      :whitelist => ApiVersion.running.map(&:with_virtual_attr_for_api),
    }
  end

  # def self.merge_hot_new
  #   temp = {}
  #   hot_series = Serie.online.shown.map do |serie|
  #     [serie.id, serie.videos.sum(:play_count)]
  #   end
  #   new_series = Serie.online.shown.map do |serie|
  #     if serie.videos.present?
  #       [serie.id, serie.videos.last.created_at.to_i]
  #     else
  #       [serie.id,0]
  #     end
  #   end
  #   hot_series.sort_by!(&:last).reverse!

  #   # likes_series = Serie.online.shown.map do |serie|
  #   #   [serie.id, serie.videos.sum(:likes_count)]
  #   # end

  #   # follow_hash = {}
  #   # follow_series = Follow.where(created_at: ((Time.now-7.days)..Time.now))
  #   # if follow_series.present?
  #   #   follow_series.each do |f|
  #   #     if f.followable_type == 'Serie'
  #   #       follow_hash["#{f.followable_id}"] = follow_hash["#{f.followable_id}"].to_i + 1
  #   #     end
  #   #   end
  #   # end
  #   # follow_arr = follow_hash.sort_by(&:last).reverse
  #   # follow_arr = follow_arr.map {|a| a[0].to_i} rescue []

  #   # remove_arr = Serie.hide.pluck(:id) + Serie.where(status: Serie::STATUS['offline']).pluck(:id)
  #   # # likes_series.sort_by!(&:last).reverse!
        
  #   # #likes_temp1 = Redis::Search.query('Xlabel',Xlabel::SLABEL[0],:conditions=>{xlabelable_type:'Serie'}).map{|v| v['details']['id']} rescue []
  #   # #likes_temp1 = Redis::Search.query('Xlabel',Xlabel::SLABEL[0]).map{|v| v['details']['id']} rescue []
  #   # likes_temp1 = Serie.online.where(recommended:Serie::RECOMMENDED['推荐']).order('recommend_order asc').pluck(:id) rescue []
  #   # # likes_temp2 = likes_series.map{|a| a[0]} rescue []
  #   # likes_temp2 = follow_arr
  #   # likes_temp = (likes_temp1 + likes_temp2 - remove_arr)
  #   # likes_temp.uniq!
  #   # likes_temp = likes_temp.join(',') rescue ''
  #   #phone_series = Redis::Search.query('Xlabel','手机剧',:conditions=>{xlabelable_type:'Serie'}).map{|v| v['details']['id']}.join(',') rescue ''
  #   likes_temp = Redis::Search.query('Xlabel', 'Get', :conditions => {xlabelable_status: 1}).map{|a| a['details']['id']}.join(',') rescue ''

  #   phone_series1 = Redis::Search.query('Xlabel','电视剧神速版', :conditions=>{xlabelable_status: 1}).map{|v| v['details']['id']}
  #   phone_series2 = Redis::Search.query('Xlabel','手机看的剧', :conditions=>{xlabelable_status: 1}).map{|v| v['details']['id']}
  #   phone_series = (phone_series1 + phone_series2).join(',') rescue ''

  #   #运动场
  #   sports_series_arr = Redis::Search.query('Xlabel', '拒绝宅', :conditions=>{xlabelable_status: 1}).map{|v| v['details']['id']}
  #   sports_series = sports_series_arr.join(',') rescue ''

  #   recommended_top_ten_series_last_week_arr = Video.top_last_week(10).map(&:serie_id)
  #   recommended_top_ten_series_last_week_arr.uniq!

  #   temp.merge({
  #     :whitelist => ApiVersion.running.map(&:with_virtual_attr_for_api),
  #     :time => Time.now.to_i,
  #     :hot_series => hot_series.map{|a| a[0]}.join(','),
  #     :new_series => new_series.map{|a| a[0]}.join(','),
  #     :phone_series => phone_series.chomp(','),
  #     :popular_series => likes_temp.chomp(','),
  #     :sports_series => sports_series.chomp(','),
  #     :recommended_top_ten_series_last_week => recommended_top_ten_series_last_week_arr.join(',')
  #   })
  # end
end

