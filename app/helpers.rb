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
end