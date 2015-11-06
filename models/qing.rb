class QingApp
  require 'ostruct'
  class QingEpisode
    def initialize(v)
      @e = OpenStruct.new
      @e.episodeNumber = v.episode? ? v.episode : ''
      @e.episode_name = v.title? ? v.title : ''
      @e.episode_playUrlForWeb =  "http://5tv.com/serie/#{v.serie_id}/videos/show/#{v.id}"
      @e.episode_playUrlForApp = "http://5tv.com/serie/#{v.serie_id}/videos/show/#{v.id}"
      @e.episode_description = v.description? ?  v.description : ''
      @e.episode_duration = v.duration? ? v.duration : ''
      @e.episode_image = '' 
      @e.episode_image_horizontal = v.cover.x300.url
      @e.episode_sizeOfPlayer = '960x540'
      @e.episode_videoAspectRatio = '16:9'
      @e.episode_downloadUrlForApp = ''
      @e.episode_downloadUrlForSource = ''
      @e.episode_downloadUrlForWeb = ''
      @e.episode_videoFormat = 'mp4'
      @e.episode_oneSentence = '' 
      @e.episode_size = '' 
      @e.episode_bps = ''
    end
    def to_hash
      @e.as_json['table']
    end
  end

  def self.episodes(s)
    temp = {episode: []}
    s.videos.online.order('episode asc').each do |v|
      temp[:episode] << QingEpisode.new(v).to_hash
    end
    temp
  end

  def initialize(serie)
    @s = serie
  end

  def attributes
    temp = {}
    temp['display'] = {
      "id" => @s.id,
      "sourceTime" => Time.now.to_i,
      "productLine" => 1,
      "name" => @s.title? ? @s.title : '',
      "originalName" => @s.title ? @s.title : '',
      "alias" => @s.description ? @s.description : '',
      "sourceType1" => '视频',
      "sourceType2" => '电视剧',
      "tags" => (Xlabel.where(xlabelable_type: 'Serie', xlabelable_id: @s.id).first.labels.first rescue ''),
      "englishName" => '',
      "poster" => @s.cover.x300.url,
      "horizontalPoster" => @s.cover.x300.url,
      "searchUrlForWeb" => 'http://5tv.com',
      "searchUrlForApp" => 'http://5tv.com',
      "playUrlForWeb" => 'http://5tv.com',
      "playUrlForApp" => 'http://5tv.com',
      "downloadUrlForApp" => 'http://5tv.com',
      "downloadUrlForSource" => 'http://5tv.com',
      "downloadUrlForWeb" => 'http://5tv.com',
      "videoFormat" => 'mp4',
      "videoSize" => '',
      #演员的信息
      "actor" => '',
      "actorUrlForWeb" => '',
      "actorUrlForApp" => '',
      #导演的信息
      "director" => '',
      "directorUrlForWeb" => '',
      "directorUrlForApp" => '',
      #作品的地区
      "contentLocation" => '',
      "contentLocationForApp" => '',
      "contentLocationForWeb" => '',
      #居中角色的介绍
      "role" => '',
      "roleUrlForWeb" => '',
      "roleUrlForApp" => '',
      #剧情分集介绍
      "dramaUrlForWeb" => '',
      #演员演的角色
      "roleActorUrl" => '',
      #音乐原声的介绍
      "musicUrl" => '',
      #剧中对白介绍
      "dialogueUrlForWeb" => '',
      #剧中角色介绍
      "roleDescriptionUrl" => '',
      #剧集年份
      "showTime" => '',
      "showTimeUrlForWeb" => '',
      "showTimeUrlForApp" => '',
      #剧集的体裁
      "genre" => '',
      "genreUrlForWeb" => '',
      "genreUrlForApp" => '',
      #剧集的描述
      "description" => @s.description? ? @s.description : '',
      "webLogo" => 'http://5tv.com/favicon.jpg',
      "status" => '',
      "inLanguage" => '中文',
      "inLanguageUrlForWeb" => '中文',
      "inLanguageUrlForApp" => '中文',
      #编剧的信息介绍
      "author" => '',
      "authorUrlForWeb" => '',
      "authorUrlForApp" => '',
      #季/部 #number
      "seasonid" => '',
      #部还是季
      "seasonType" => '',
      #一共多少季
      "totalSeasonNumber" => '',
      #最新的一集
      "newestEpisode" => '',
      # 1表示收费 0表示免费
      "vipFlag" => '',
      #是否是自制剧集
      "isMadeByOwn" => '',
      #是否删除此作品
      "isDelete" => '',
      #这一季有多少集
      "numberOfEpisodes" => '',
      #所有季在一起有多少集
      "numberOfEpisodes2" => '',
      #清晰度: 超清，标清，普清
      "definition" => '',
      #最新一集播放时间
      "dateModified" => '',
      #新季预计播放时间
      "newseasonShowTime" => '',
      #哪一版的剧集 例如80版的
      "version" => '',
      #是否是独家资源
      "isExclusive" => 1,
      #是否是正版
      "isOriginal" => 1,
      #作品播出的电视台
      "provider" => '',
      #一句话简短的描述
      "oneSentenceDescription" => '',
      #用户的评分
      "rating" => '',
      #评分用户的总数
      "ratingCount" => '',
      #用户可以给的最高评分
      "maxRating" => '',
      #用户评论的总数
      "reviewCount" => '' ,
      "reviewUrlForWeb" => '' ,
      "reviewUrlForApp" => '' ,
      #用户短评的总数
      "reviewShortCount" => '' ,
      "reviewShortUrlForApp" => '' ,
      "reviewShortUrlForWeb" => '' ,
      #累计播放量
      "accumulatedPlayedNumber" => '' ,
      #当天播放量
      "oneDayPlayedNumber" => '' ,
      #累计顶和踩
      "accumulatedTopOrStep" => '' ,
      #当日的
      "oneDayTopOrStep" => '' ,
      #累计引用
      "accumulatedReferenceNumber" => '' ,
      "oneDayReferenceNumber" => '' ,
      #累计收藏
      "accumulatedCollectionNumber" => '' ,
      "oneDayCollectionNumber" => '' ,
      #累计评论
      "accumulatedComments" => '' ,
      "oneDayComments" => '' ,
      #预告片的名字
      "trailer_name" => '' ,
      "trailer_playUrlForWeb" => '' ,
      "trailer_playUrlForApp" => '' ,
      "trailer_image" => '' ,
      "trailer_image_horizontal" => '' ,
      "trailer_duration" => '' ,
      "trailer_sizeOfPlayer" => '' ,
      "trailer_videoAspectRatio" => '' ,
      #作品预期上映时间
      "onlinetime" => '' ,
      "oneWeekPlayNum" => '' ,
      "bps" => '' ,
      "episodes" => QingApp.episodes(@s),
      "appInfo" => {package: '', versionname: '', versioncode: '', sourceName: '', siteUrlForWeb: '', siteUrlForPc: ''}
    }
    temp
  end

  def get_url_unit
    APP_CACHE.fetch("QingApp/series/#{@s.id}") do
      # freq: always、hourly、daily、weekly、monthly、yearly、never
      {loc: "http://5tv.com/qing/#{@s.id}", lastmod: Time.now.to_s(:db).split.join('T'), changefreq: 'hourly', priority: 1, data: self.attributes}
    end
  end

  def self.cache_remove
    APP_CACHE.delete_matched("QingApp/*")
  end


end