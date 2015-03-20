module Weixin2
  class App
    module ImageHelper
      
      def image(msg)
        image_test
      end

      private
      def image_test
        {message: 'hello'}.to_json
      end
    end

    helpers ImageHelper
  end
end