module Weixin2
  class App
    module TextHelper
      
      def text(msg)
        search(msg)
      end

      
      private
      def search(msg)
        content = msg.Content.force_encoding('utf-8')
        url = "http://#{UPHOST}/v1/search/wechat_search?key=#{content}&account_id=29714"
        url = URI.encode(url.strip)
        string = Timeout::timeout(20) do
          RestClient.get(url)
        end
        string_arr = JSON.parse(string)
        item = []
        string_arr.each do |hash|
          item << item_create(hash)
        end
        news_deliver(msg, item)
      end

      
    end

    helpers TextHelper
  end
end