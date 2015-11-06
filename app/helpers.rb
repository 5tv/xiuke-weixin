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

  def send_video_message(openid, video_id, timepoint)
    video_info_url = "http://5tv.com/app/api/videos/video_info/#{obj['video_id']}"
    video = RestClient.get(video_info_url)
    obj = JSON.parse(video)
    message = {
      touser: openid,
      msgtype: 'news',
      news: {
        articles: [
          {
            title: obj['title'],
            description: obj['description'],
            url: "http://5tv.com/serie/#{obj['serie_id']}/videos/show/#{video_id}?timepoint=#{timepoint}",
            picurl: obj['covers']['x200']
          }
        ]
      }
    }.to_json
    message = JSON.parse(message)
    WEIXIN_CLIENT.message_custom.send(message)
  end

end