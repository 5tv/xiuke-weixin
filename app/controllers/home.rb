Weixin2::App.controllers :home do
  get :weixin_follow, map: '/weixin_follow' do
    account_id = params[:account_id]
    video_id = params[:video_id]
    timepoint = params[:timepoint]
    prng = Random.new
    scene_id = prng.rand(100_000_000_000)
    WEIXIN_CLIENT.authenticate unless WEIXIN_CLIENT.access_token.present?
    access_token = WEIXIN_CLIENT.access_token
    qrcode_url = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{access_token}"
    CACHE.write("/weixin_follow/#{scene_id}", {
      account_id: account_id,
      video_id: video_id,
      timepoint: timepoint
    }.to_json)
    qrcode_return = RestClient.post(qrcode_url, {
      action_name: 'QR_SCENE',
      action_info: {
        scene: {
          scene_id: scene_id
        }
      }
    }.to_json)
    obj = JSON.parse(qrcode_return)
    {
      error_message: "",
      data: {
        ticket: obj['ticket'],
        scene_id: scene_id
      }
    }.to_json
  end

  get :qrcode_with_ticket do
  end

  get :index, map: '/' do
    if params[:echostr].present?
      params[:echostr]
    end
  end

  get :game_random, map: '/game_random' do
    @lines = ["2048", "baba", "baozi", "bbjx", "bdsjm", "biaoche", "blglez", "bsqpz", "bttz", "bunengsi", "cdd", "ceast", "cjrst", "cpp", "cs", "cscg", "cube", "daoguo", "ddb", "diandeng", "diaoyu", "dlss", "dlxfk", "dqe", "duimutou", "duolao", "duxinshu", "dwy", "dwz", "fangyan", "feidegenggao", "fkfzm", "fytkzc", "gongfumao", "gqtz", "gudaye", "hczz", "heibai", "hl", "honghaishilv", "ice_bucket", "iq", "jb", "jg", "jianren", "jicilang", "jolin", "jssjm", "jyfy", "jyfy2", "kanshu", "kuaipao", "lbyhbyc", "ld", "liankan", "llll", "memeda", "mingxuanyixian", "mishi", "mmttt", "mnbyg", "mnygl", "money", "monkey", "mtl", "mxcz", "mzpk", "naoyangyang", "nddsc", "ndtnrgclm", "njdsb", "pigbaby", "pigu", "pxfzm", "qedfc", "qie", "qiexigua", "qifu", "qingwa", "qixi", "qixi1", "qmbttz", "qmxzfzm", "qmxzfzm2", "qmykl", "qpjzg", "qwt", "rjd", "se", "se2", "selang", "semo", "shenjingmao", "shenjingmao-zhuangbiban", "shenjingmao2", "sheqiu", "shit", "shouzhi", "sqs", "sqsdscj", "tangguo", "tzbp", "wbk", "weidao", "wzdz", "wzxgz", "xiaoniaofeifei", "xiaopingguo", "xiaosan", "xiaoshuai", "xindonglian", "xiongchumo", "xxoo", "xz120", "yang", "yao", "ybdz", "ygj", "yh", "yibihua", "ymhddzc", "yuebing", "yzcs", "zazhi", "zhaonige", "zhaonimei", "zhizhuxia", "zhua", "zhuogui", "zqdn", "zuiqiangyanli", "zuqiu", "zz", "zzs"] 
    redirect "/games/#{@lines[rand(134)]}/index.html"
  end

  get :test, map: '/test' do
    begin
      p params
      test
    rescue=>e
      STDERR.puts e
      STDERR.puts e.backtrace.join("\n")
      halt 500, {message: e.to_s}.to_json
    end
  end

  post :test, map: '/test' do
    p params
    p request.body.read
    text('hello')
  end

  post :create, map: '/' do
    begin
      # content_type :xml, :charset => 'utf-8'
      puts request.body.read
      message = request.env[Weixin::Middleware::WEIXIN_MSG]
      #logger.info "原始数据: #{request.env[Weixin::Middleware::WEIXIN_MSG_RAW]}"
      new_message = msg_router(message) unless message.nil?
      new_message
    rescue=>e
      STDERR.puts e
      STDERR.puts e.backtrace.join("\n")
      halt 500, {message: e.to_s}.to_json
    end
  end
  

end
