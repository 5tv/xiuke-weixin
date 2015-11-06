class WeixinSdk < ActiveRecord::Base

  def self.access_token
    token = APP_CACHE.read :weixin_token
    if token == nil
      self.update
    else
      if Time.now.to_i - self.expired > 6500
        self.update
      end
    end
    APP_CACHE.read :weixin_token
  end

  def self.ticket
    ticket = APP_CACHE.read :weixin_ticket
    if ticket == nil
      self.update
    else
      if Time.now.to_i - self.expired > 6500
        self.update
      end
    end
    APP_CACHE.read :weixin_ticket
  end

  def self.expired
    APP_CACHE.read :weixin_expired
  end

  def self.update
    token = Timeout::timeout(20) do
      JSON.parse(
        RestClient.get("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{WeixinAuth.appid}&secret=#{WeixinAuth.appsecret}")
        )['access_token']
    end

    ticket = Timeout::timeout(20) do
      JSON.parse(
        RestClient.get("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{token}&type=jsapi")
          )['ticket']
    end
    
    APP_CACHE.write :weixin_ticket, ticket 
    APP_CACHE.write :weixin_token, token
    APP_CACHE.write :weixin_expired, Time.now.to_i
  rescue 
    raise "访问超时，请稍后重试"
  end

  def access_token
    WeixinSdk.access_token
  end

  def ticket
    WeixinSdk.ticket
  end

  def self.weixin_sign hash
    hash['url'] = hash['url'].split('#')[0]
    hash.merge!({'noncestr' => 'xiukeshibukezhanshengde', 'jsapi_ticket' => WeixinSdk.ticket})
    string = hash.sort_by{|k,v| k}.map{|v| v.join('=')}.join('&')
    Digest::SHA1.hexdigest string
  end

end
