module Weixin2
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions
    set :public_folder, '/public'
    use Weixin::Middleware, WX_ACCOUNT['token'], '/' 
    configure do
      set :wx_id, WX_ACCOUNT['wx_account_id']
    end
  end
end
