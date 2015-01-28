Weixin2::App.controllers :home do
  
  get :index, map: '/' do
    if params[:echostr].present?
      params[:echostr]
    end
  end

  get :test, map: '/test' do
    test
  end

  post :create, map: '/' do
    content_type :xml, 'charset' => 'utf-8'
    message = request.env[Weixin::Middleware::WEIXIN_MSG]
    logger.info "原始数据: #{request.env[Weixin::Middleware::WEIXIN_MSG_RAW]}"
    new_message = msg_router(message) unless message.nil?
    new_message
  end
  

end
