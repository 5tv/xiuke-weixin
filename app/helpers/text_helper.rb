module Weixin2
  class App
    module TextHelper
      
      def text(msg)
        search(msg)
      end

      
      private
      def search(msg)
        content = msg.Content.force_encoding('utf-8')
        string = Timeout::timeout(20) do
          RestClient.get("http://5tv.com/v1/search/wechat_search?key=#{content}&account_id=29714")
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