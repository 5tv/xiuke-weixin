module Weixin2
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions
    use Weixin::Middleware, WX_ACCOUNT['token'], '/' 
    configure do
          set :wx_id, WX_ACCOUNT['wx_account_id']
    end
    ##
    # Caching support.
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache.new(:LRUHash) # Keeps cached values in memory
    # set :cache, Padrino::Cache.new(:Memcached) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Memcached, '127.0.0.1:11211', :exception_retry_limit => 1)
    # set :cache, Padrino::Cache.new(:Memcached, :backend => memcached_or_dalli_instance)
    # set :cache, Padrino::Cache.new(:Redis) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Redis, :host => '127.0.0.1', :port => 6379, :db => 0)
    # set :cache, Padrino::Cache.new(:Redis, :backend => redis_instance)
    # set :cache, Padrino::Cache.new(:Mongo) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Mongo, :backend => mongo_client_instance)
    # set :cache, Padrino::Cache.new(:File, :dir => Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options.
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 505 do
    #     render 'errors/505'
    #   end
    #
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
                    v_open = OpenStruct(v)
                    title = v_open.title
                    desc = v_open.description
                    cover = v_open.cover
                    link_url = v_open.url
                    Weixin.item(title, desc, cover, link_url)
                end
                    Weixin.news_msg(msg.ToUserName, msg.FromUserName, items)
            #更多--关于
            when 'about'
                about = '客户服务\n邮箱：feedback@xiuke.tv\n\n商务合作\n邮箱：contact@xiuke.tv\n\n企业合作\n邮箱：yanglicong@xiuke.tv\n\n秀客微博：@秀客微节目\n秀客微信：秀客短视频（xiuke-tv)'
                Weixin.text_msg(msg.ToUserName, msg.FromUserName, about)
            #更多--我的试片
            when 'previews'
                ## 需要补全url地址
                videos_string = RestClient.get("http://5tv.com/weixin/wx_mypreviews?weixin_openid=#{msg.FromUserName}")
                videos_hash = JSON.parse(videos_string)
                if !videos_hash['message'].present?
                    videos_array = videos_hash['videos']
                    items = videos_array.map do |v|
                        v_open = OpenStruct(v)
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

        get '/redirect' do
            content_type :xml, 'charset' => 'utf-8'
            message = request.env[Weixin::Middleware::WEIXIN_MSG]            
            redirect "http://5tv.com/bind?weixin_openid=#{message.FromUserName}"
            # redirect "http://5tv.com/"
        end
    end

  end
end
