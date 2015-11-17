module Weixin2
  class App
    module EventHelper
      def event(msg)
        case msg.Event
        when 'subscribe'
          subscribe(msg)
        when 'unsubscribe'
          unsubscribe(msg)
        when 'CLICK'
          click(msg)
        when 'VIEW'
          view(msg)
        when 'LOCATION'
          event_location(msg) 
        when 'SCAN'
          event_scan(msg)
        else
          Weixin.text_msg(msg.ToUserName, msg.FromUserName, '未知事件')
        end
      end

      private
      def subscribe(msg)
        welcome = '欢迎您关注秀客网官方微信服务号。精彩内容尽在秀客。'
        Weixin.text_msg(msg.ToUserName, msg.FromUserName, welcome)
        event_scan(msg)
      end

      def unsubscribe(msg)
        # waiting_you_subscribe_next = '你一定会回来的'
        # Weixin.text_msg(msg.ToUserName, msg.FromUserName, waiting_you_subscribe_next)
      end

      def view(msg)
      end

      def event_scan(msg)
        scene_id = msg.EventKey
        open_id = msg.FromUserName
        result = CACHE.read("/weixin_follow/#{scene_id}")
        obj = JSON.parse(result)
        user_info = get_userinfo(msg)
        account_info = get_account_info(user_info['unionid'], open_id, user_info['nickname'], user_info['headimgurl'])
        #RestClient.get("http://#{WEIXIN_SERVER}/weixinapi/send_video_message?openid=#{open_id}&video_id=#{obj['video_id']}&time=#{obj['time']}")
        send_video_message(open_id, obj['video_id'], obj['time'], account_info['access_token'])
      end

      def send_video_message(openid, video_id, time, access_token)
        video_info_url = "http://#{UPHOST}/app/api/videos/video_info/#{video_id}"
        time ||= 0
        video = RestClient.get(video_info_url)
        obj = JSON.parse(video)
        follow_serie(access_token, obj['serie_id'])
        message = {
          touser: openid,
          msgtype: 'news',
          news: {
            articles: [
              {
                title: obj['title'],
                description: obj['description'],
                url: "http://#{UPHOST}/serie/#{obj['serie_id']}/videos/show/#{video_id}?time=#{time}",
                picurl: obj['covers']['x200']
              }
            ]
          }
        }.to_json
        message = JSON.parse(message)
        WEIXIN_CLIENT.message_custom.send(message)
      end

      def get_account_info(unionid, openid, nickname, headimgurl)
        weixin_login_url = "http://#{APISERVER}/v1/accounts/weixin_login?openid=#{openid}&nickname=#{nickname}&headimgurl=#{headimgurl}&openid_public=#{openid}"
        result = RestClient.get(URI.encode(weixin_login_url))
        obj = JSON.parse(result)
      end

      def get_userinfo(msg)
        t = WEIXIN_CLIENT.get_access_token
        weixin_openid = msg.FromUserName
        union_link="https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{t}&openid=#{weixin_openid}&lang=zh_CN"
        union_string = RestClient.get(union_link)
        obj = JSON.parse(union_string)
      end

      def follow_serie(token, serie_id)
        if RACK_ENV == 'production'
          follow_url = "https://#{APISERVER}/v1/follows"
        else
          follow_url = "http://#{APISERVER}/v1/follows"
        end
        result = RestClient::Request.execute(
          :url => follow_url,
          :method => :post,
          :verify_ssl => false,
          :payload => {
            token: token,
            'follow[followable_id]' => serie_id,
            'follow[followable_type]' => 'Serie'
          },
          :headers => {
            'Accept' => 'application/vnd.5tv.v3+json',
            'Authorization' => token
          }
        )
      end

      def event_location(msg)
      end

      def click(msg)
        send("click_#{msg.EventKey}",msg)
      end

      def click_follows(msg)
        series = RestClient.get("http://#{UPHOST}/weixin/follows?weixin_openid=#{msg.FromUserName}")
        series_h = JSON.parse(series)
        if series_h.is_a? Array
          items = series_h.map{|s| item_create(s)}
          news_deliver(msg, items)
        else
          text_deliver(msg, series_h['message'])
        end
      end

      def click_classic(msg)
        series = RestClient.get("http://#{UPHOST}/weixin/rapid_series")
        series_h = JSON.parse(series)
        items = series_h.map{|s| item_create(s)}
        news_deliver(msg, items)
      end

      def click_joke(msg)
        series = RestClient.get("http://#{UPHOST}/weixin/joke_series")
        series_h = JSON.parse(series)
        items = series_h.map{|s| item_create(s)}
        news_deliver(msg, items)
      end

      def click_click_for_more(msg)
        series = RestClient.get("http://#{UPHOST}/weixin/more_series")
        series_h = JSON.parse(series)
        items = series_h.map{|s| item_create(s)}
        news_deliver(msg, items)
      end

      def click_get_tv(msg)
        text = '即将上线'
        text_deliver(msg, text)
      end

      def click_play_game(msg)
        text = '即将上线'
        text_deliver(msg,text)
      end

      def click_pick_up(msg)

      end
    end

    helpers EventHelper
  end
end
