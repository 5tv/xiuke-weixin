module Weixin2
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions
    use Weixin::Middleware, WX_ACCOUNT['token'], '/' 
    configure do
          set :wx_id, WX_ACCOUNT['wx_account_id']
    end

    helpers do
      def msg_router(msg)
        case msg.MsgType
        when 'text'
          # text message handler
        when 'image'
          # image message handler
        when 'location'
          # location message handler
        when 'link'
          # link message handler
        when 'event'
          # event messge handler
          case msg.Event
          when 'subscribe'
            welcome = '欢迎您关注秀客网官方微信服务号，点击‘系列’立即观看5tv最新制作的系列 点击‘随便看看’立即观看精彩短视频。精彩内容尽在秀客。'
            Weixin.text_msg(msg.ToUserName, msg.FromUserName, welcome)
          when 'unsubscribe'
            waiting_you_subscribe_next = '你一定会回来的'
            Weixin.text_msg(msg.ToUserName, msg.FromUserName, waiting_you_subscribe_next)
          when 'CLICK'
            case msg.EventKey
            #系列
            when 'serie'
                serie_string = RestClient.get('http://5tv.com/api/v3/series')
                serie_hash = JSON.parse(serie_string)
                serie = OpenStruct.new(serie_hash)
                items = serie.series.map do |s|
                    s_open = OpenStruct.new(s)
                    title = s_open.title
                    desc = s_open.description
                    cover = s_open.cover
                    link_url = "http://5tv.com/series/show?id=#{s_open.id}"
                    Weixin.item(title, desc, cover, link_url)
                end
                Weixin.news_msg(msg.ToUserName, msg.FromUserName, items)
            #随便看看
            when 'lookingaround'
                videos_string = RestClient.get("http://5tv.com/weixin/wx_lookingaround")
                videos_hash = JSON.parse(videos_string)
                videos_array = videos_hash['videos']
                items = videos_array.map do |v|
                    v_open = OpenStruct.new(v)
                    title = v_open.title
                    desc = v_open.description
                    cover = v_open.cover
                    link_url = v_open.url
                    Weixin.item(title, desc, cover, link_url)
                end
                    Weixin.news_msg(msg.ToUserName, msg.FromUserName, items)
            #更多--关于
            when 'about'
                about = "客户服务\n邮箱：feedback@xiuke.tv\n\n商务合作\n邮箱：contact@xiuke.tv\n\n企业合作\n邮箱：yanglicong@xiuke.tv\n\n秀客微博：@秀客微节目\n秀客微信：秀客短视频（xiuke-tv)"
                Weixin.text_msg(msg.ToUserName, msg.FromUserName, about)
            #更多--我的试片
            when 'previews'
                ## 需要补全url地址
                videos_string = RestClient.get("http://5tv.com/weixin/wx_mypreviews?weixin_openid=#{msg.FromUserName}")
                videos_hash = JSON.parse(videos_string)
                if !videos_hash['message'].present?
                    videos_array = videos_hash['videos']
                    items = videos_array.map do |v|
                        v_open = OpenStruct.new(v)
                        title = v_open.title
                        desc = v_open.description
                        cover = v_open.cover
                        link_url = v_open.url
                        Weixin.item(title, desc, cover, link_url)
                    end
                    Weixin.news_msg(msg.ToUserName, msg.FromUserName, items)
                else
                    Weixin.text_msg(msg.ToUserName, msg.FromUserName, videos_hash['message'])
                end
            else
                Weixin.text_msg(msg.ToUserName, msg.FromUserName, ' ')    
            end
          when 'VIEW'
          when 'LOCATION'
            Weixin.text_msg(msg.ToUserName, msg.FromUserName, ' ')           
          else 
            Weixin.text_msg(msg.ToUserName, msg.FromUserName, '未知事件')
          end
        when 'voice'
          # voice message handler
        when 'video'
          # video message handler
        else
          Weixin.text_msg(msg.ToUserName, msg.FromUserName, '未知消息类型')
        end
      end
    end

    controllers do 
        get "/" do
            params[:echostr]
        end

        post '/' do
            content_type :xml, 'charset' => 'utf-8'
            message = request.env[Weixin::Middleware::WEIXIN_MSG]
            logger.info "原始数据: #{request.env[Weixin::Middleware::WEIXIN_MSG_RAW]}"

            # handle the message according to your business logic
            new_message = msg_router(message) unless message.nil?
            new_message
        end
        
    end

  end
end
