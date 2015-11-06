class ApiKey < ActiveRecord::Base
  acts_as_cached
  belongs_to    :account
  before_create :generate_access_token, :generate_activate_token
  after_create  do
    send_email_activate_token if self.account.email.present?
  end

  def send_email_activate_token_bak
    self.account.update_attribute(:activate_token_created_at, Time.now)
    Mailgun.send_html_message("感谢您注册5TV！", self.account.email,
                                "<h2>亲爱的#{self.account.name}：</h2>
                                <p></p>
                                <p>　　<strong>恭喜您注册了5TV，享受最带感的移动视频娱乐！</strong><br/>
                                　　<strong>为了保障您的帐号安全，建议您尽快进行邮箱验证、手机验证。</strong> <br/>
                                　　<strong>邮箱验证链接：<a href=\"http://5tv.com/user_email_verify?i=#{self.activate_token}\">\"http://5tv.com/user_email_verify?i=#{activate_token}\"</a>（如果您的邮箱不支持链接点击，请将以上链接复制到浏览器地址栏来访问）</strong></p>
                                
                                <p>　　<strong>（如果您的邮箱不支持链接点击，请将以上链接复制到浏览器地址栏来访问。）</strong></p>

                                <p>　　<strong>该链接仅在7日内点击有效。</strong></p>

                                <p><strong> 感谢您的加入，5TV将不断的努力，让您的手机充满最新奇最精彩的视频娱乐！</strong></p>

                                <p><strong> 如果您没有用这个邮箱进行本注册，请<a>点击此处</a></strong><br/>

                                <p><strong>网站访问 http://5tv.com　</strong><br/>

                                <p>5TV运营团队 敬上<br/>

                                <strong>此邮件由系统自动发送，请勿回复。</strong></p>"
    )
  end

  def send_email_activate_token
    self.account.update_attribute(:activate_token_created_at, Time.now)
    Mailgun.send_html_message("感谢您注册5TV！", self.account.email,
                                " <div style='width:100%; background-color:#f3f3f3; margin:0px;'><div style='width:728px; max-width:100%; margin:0px auto; padding: 30px 0;background-color:#f3f3f3'>
    <div style='position:relative; overflow:hidden; width:100%; height:88px; border-top-left-radius:10px; border-top-right-radius:10px;' >
      <img src='http://7vilst.com1.z0.glb.clouddn.com/v1/head.png' style='width:auto; height:88px;'>
      <a href='http://5tv.com' style='position:absolute; top:14px; left:30px;'><img src='http://7vilst.com1.z0.glb.clouddn.com/v1/logo.png'></a>
      <img src='http://7vilst.com1.z0.glb.clouddn.com/v1/5niang.png' style='position:absolute; bottom:0px; right:30px;'>
    </div>
    <div style='position:relative; overflow:hidden; background-color:#fff; padding:30px 40px; border-bottom-left-radius:10px; border-bottom-right-radius:10px;'>
      <p style='font-size:1.2em; color:#ff2c4c;'>#{self.account.name}：</p>
      <br>
      <p>恭喜您注册了5tv，享受最带感的移动视频娱乐！</p>
      <p>为了保障您的帐号安全，建议您尽快进行邮箱验证。 </p>
      <p><a href='http://5tv.com/user_email_verify?i=#{self.activate_token}' style='display:inline-block; padding:8px 16px; font-size:1.2em; color:#fff; background-color:#e73849; margin:15px 0; border-radius:5px; text-decoration:none; box-shadow:2px 2px 0px 0px #c12c3a;'>确认邮箱</a></p>
      <p>邮箱验证链接：<a href='http://5tv.com/user_email_verify?i=#{self.activate_token}'>http://5tv.com/user_email_verify?i=#{self.activate_token}</a></p>
      <p>如果您的邮箱不支持链接点击，请将以上链接复制到浏览器地址栏来访问。</p>
      <p>该链接仅在7日内点击有效。</p>
      <br>
      <p style='font-size:1.2em;'>感谢您的加入，5tv将不断的努力，让您的手机充满新奇精彩的视频娱乐！</p>
      <br>
      <p>如果您没有用这个邮箱进行本注册，请无视本邮件，</p>
      <p>或网站访问 <a href='http://5tv.com'>http://5tv.com</a> 了解详情！</p>
      <div style='position:relative; margin-top:30px; width:100%; min-height:273px; overflow:hidden; background-image:url(http://7vilst.com1.z0.glb.clouddn.com/v1/redbg.png); text-align:center;'>
        <img src='http://7vilst.com1.z0.glb.clouddn.com/v1/m5.png' style='display:inline-block; margin-top:30px; height:2em;'>
        <img src='http://7vilst.com1.z0.glb.clouddn.com/v1/m3.png' style='display:inline-block; margin-top:15px; height:2em;'><br>
        <img src='http://7vilst.com1.z0.glb.clouddn.com/v1/m1.png' style='display:inline-block; margin-top:15px; height:2em;'>
        <img src='http://7vilst.com1.z0.glb.clouddn.com/v1/me.png' style='display:inline-block; margin-top:15px; height:2em;'><br>
        <img src='http://7vilst.com1.z0.glb.clouddn.com/v1/2dbarcode.png' style='display:inline-block; margin:20px 0 0 0;'><br>
        <img src='http://7vilst.com1.z0.glb.clouddn.com/v1/text_scanforapp.png' style='display:inline-block; margin:20px 0; max-width:90%; height:1.2em;'>
      </div>
      <div style='position:relative; font-size:0.8em; color:#ababab; text-align:center;'>
        <p>如果这封邮件里的信息不是您所需要的，您可以直接无视此邮件，无需任何操作。</p>
        <p>如有任何问题与建议，可以直接联系我们，我们将尽快为您解答：</p>
        <p>Email：<a href='mailto:contact@5tv.com' style='color:#ababab;'>contact@5tv.com</a>，或访问5tv官网在用户社区里留言给我们！</p>
        <p>为保证邮箱正常接收，请您将 service@5tv.com 添加进您的通讯录</p>
      </div>

    </div>
  </div></div>"
    )
  end

  def g_pw_verification_token
    pw_verification_token = SecureRandom.hex
    self.update_attribute(:pw_verification_token, pw_verification_token)
    pw_verification_token
  end

  private
    def generate_access_token
      begin
        self.access_token = SecureRandom.hex
      end while self.class.exists?(access_token: access_token)
    end

    def generate_activate_token
      self.activate_token = SecureRandom.hex
    end

end
