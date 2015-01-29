Weixin2::App.helpers do
  def msg_router(msg)
    case msg.MsgType
    when 'text'
      text(msg)
    when 'image'
      image(msg)
    when 'location'
      location(msg)
    when 'link'
      link(msg)
    when 'event'
      event(msg)   
    when 'voice'
      voice(msg)
    when 'video'
      video(msg)
    else
      other(msg)
    end
  end

  def text(msg)
    case msg.Content.force_encoding('utf-8')
    when '大转盘'
      text_lottery(msg)
    else
    end
  end

  def text_lottery(msg)
    hash = {title: '5tv大摇奖,小伙伴们快来抢!', description: '快来领取神秘大奖', cover: "http://#{UPHOST}/yaojiang.jpg", url: "http://#{UPHOST}/games/zhuanpan/zhuanpan.html"}
    item = []
    item << item_create(hash)
    news_deliver(msg, item)
  end

  def image(msg)
  end

  def location(msg)
  end

  def link(msg)
  end

  def voice(msg)
  end

  def video(msg)
  end

  def other(msg)
  end

  def event(msg)
    case msg.Event
    when 'subscribe'
      event_subscribe(msg)
    when 'unsubscribe'
      event_unsubscribe(msg)
    when 'CLICK'
      event_click(msg)
    when 'VIEW'
      event_view(msg)
    when 'LOCATION'
      event_location(msg)        
    else 
      Weixin.text_msg(msg.ToUserName, msg.FromUserName, '未知事件')
    end
  end

  def event_subscribe(msg)
    welcome = '欢迎您关注秀客网官方微信服务号，点击‘系列’立即观看5tv最新制作的系列 点击‘随便看看’立即观看精彩短视频。精彩内容尽在秀客。'
    Weixin.text_msg(msg.ToUserName, msg.FromUserName, welcome)
  end

  def event_unsubscribe(msg)
    # waiting_you_subscribe_next = '你一定会回来的'
    # Weixin.text_msg(msg.ToUserName, msg.FromUserName, waiting_you_subscribe_next)
  end

  def event_view(msg)
  end

  def event_scan(msg)
  end

  def event_location(msg)
  end

  def event_click(msg)
    send("event_click_#{msg.EventKey}",msg)
  end

  def event_click_follows(msg)
    series = RestClient.get("http://#{UPHOST}/weixin/follows?weixin_openid=#{msg.FromUserName}")
    series_h = JSON.parse(series)
    if series_h.is_a? Array
      items = series_h.map{|s| item_create(s)}
      news_deliver(msg, items)
    else
      text_deliver(msg, series_h['message'])
    end
  end

  def event_click_classic(msg)
    series = RestClient.get("http://#{UPHOST}/weixin/rapid_series")
    series_h = JSON.parse(series)
    items = series_h.map{|s| item_create(s)}
    news_deliver(msg, items)
  end

  def event_click_joke(msg)
    series = RestClient.get("http://#{UPHOST}/weixin/joke_series")
    series_h = JSON.parse(series)
    items = series_h.map{|s| item_create(s)}
    news_deliver(msg, items)
  end

  def event_click_click_for_more(msg)
    series = RestClient.get("http://#{UPHOST}/weixin/more_series")
    series_h = JSON.parse(series)
    items = series_h.map{|s| item_create(s)}
    news_deliver(msg, items)
  end

  def event_click_get_tv(msg)
    text = '即将上线'
    text_deliver(msg, text)
  end

  def event_click_play_game(msg)
    text = '即将上线'
    text_deliver(msg,text)
  end

  def event_click_pick_up(msg)

  end

  def item_create(hash)
    hash.symbolize_keys!
    title = hash[:title]
    desc = hash[:description]
    cover = hash[:cover]
    url = hash[:url]
    Weixin.item(title, desc, cover, url)
  end

  def news_deliver(msg, items)
    Weixin.news_msg(msg.ToUserName, msg.FromUserName, items)
  end

  def text_deliver(msg,text)
    Weixin.text_msg(msg.ToUserName, msg.FromUserName, text)
  end

  def test
    {message: 'this is test'}.to_json
  end

  def get_unionid(msg)
    if WEIXIN_CLIENT.expired? || WEIXIN_CLIENT.access_token.nil?
      WEIXIN_CLIENT.authenticate
      t = WEIXIN_CLIENT.access_token
      weixin_openid = msg.FromUserName
      union_link="https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{t}&openid=#{weixin_openid}&lang=zh_CN"
      union_string = RestClient.get(union_link)
      union_json = JSON.parse(union_string)
      unionid = union_json['unionid']
    else
      t = WEIXIN_CLIENT.access_token
      weixin_openid = msg.FromUserName
      union_link="https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{t}&openid=#{weixin_openid}&lang=zh_CN"
      union_string = RestClient.get(union_link)
      union_json = JSON.parse(union_string)
      unionid = union_json['unionid']
    end
  end

end