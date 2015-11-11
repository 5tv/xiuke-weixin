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

  def send_video_message(openid, video_id)
    video_info_url = "http://5tv.com/app/api/videos/video_info/#{video_id}"
    time ||= 0
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
            url: "http://5tv.com/serie/#{obj['serie_id']}/videos/show/#{video_id}?time=#{time}",
            picurl: obj['covers']['x200']
          }
        ]
      }
    }.to_json
    message = JSON.parse(message)
    WEIXIN_CLIENT.message_custom.send(message)
  end
end