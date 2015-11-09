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
          # Weixin.text_msg(msg.ToUserName, msg.FromUserName, '扫码啦！！我是天才')
          # event_scan(msg)
          # Weixin.text_msg(msg.ToUserName, msg.FromUserName, "OpenId: #{msg.FromUserName} msg: #{msg.EventKey}")
          event_scan(msg)
          # Weixin.text_msg(msg.ToUserName, msg.FromUserName, '扫码啦！！我是天才')       
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
        account_info = get_account_info(user_info['unionid'], user_info['nickname'], user_info['headimgurl'])
        # Weixin.text_msg(msg.ToUserName, msg.FromUserName, "userinfo: #{account_info.to_json}")
        # Weixin.text_msg(msg.ToUserName, msg.FromUserName, "unionid: #{user_info.to_json}")

        # create_account(unionid)
        # send_video_message(open_id, obj['video_id'], obj['time'], obj['type'])
        # Weixin.text_msg(msg.ToUserName, msg.FromUserName, "OpenId: #{msg.FromUserName} scene_id: #{msg.EventKey} ticket: #{msg.Ticket}")
      end

      def send_video_message(openid, video_id, time, type)
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

      
      def get_account_info(openid, nickname, headimgurl)
        weixin_login_url = "http://api.5tv.com/v1/accounts/weixin_login?openid=#{openid}&nickname=#{nickname}&headimgurl=#{headimgurl}"
        result = RestClient.get(URI.encode(weixin_login_url))
        obj = JSON.parse(result)
      end

      def create_account(unionid)
        
      end

      def get_userinfo(msg)
        if WEIXIN_CLIENT.expired? || WEIXIN_CLIENT.access_token.nil?
          WEIXIN_CLIENT.authenticate
          t = WEIXIN_CLIENT.access_token
          weixin_openid = msg.FromUserName
          union_link="https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{t}&openid=#{weixin_openid}&lang=zh_CN"
          union_string = RestClient.get(union_link)
          obj = JSON.parse(union_string)
          # unionid = union_json['unionid']
        else
          t = WEIXIN_CLIENT.access_token
          weixin_openid = msg.FromUserName
          union_link="https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{t}&openid=#{weixin_openid}&lang=zh_CN"
          union_string = RestClient.get(union_link)
          obj = JSON.parse(union_string)
          # unionid = union_json['unionid']
        end
      end

      def follow_serie
        
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