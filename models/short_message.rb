#coding: utf-8
class ShortMessage < ActiveRecord::Base
  belongs_to :account
  PURPOSE = {"注册验证码" => 10, "找回密码验证码" => 20, "系统提示" => 30, "登录验证码" => 50}
  REGISTER_TOKEN_VALID = 30.minutes
  FORGET_TOKEN_VALID = 30.minutes
  LOGIN_TOKEN_VALID = 30.minutes
  
  scope :today, -> { where( "created_at >= '#{Date.today}'" ) }
  scope :register, -> { where( "purpose = '#{PURPOSE["注册验证码"]}'" ) }
  scope :forget_pwd, -> { where( "purpose = '#{PURPOSE["找回密码验证码"]}'" ) }
  scope :last3min, ->{ where( "send_at >= '#{Time.current - FORGET_TOKEN_VALID}'" ) }

  def self.find_or_new_token(phone, purpose, account_id=nil)
    token = ShortMessage.where(phone: phone, purpose: purpose, account_id: account_id).first
    if token && token.invalid_date?
      token.update_attribute(:token, ShortMessage.make_token) 
    else
      # 原来写的是create!
      token = ShortMessage.new(account_id: account_id, phone: phone, token: ShortMessage.make_token, purpose: purpose, sent_at: Time.now)
    end   
    token
  end

  # def self.send_msg(phone, purpose, message = '')
  #   unless RACK_ENV == "production"
  #     res = `curl "http://sms.mobset.com/SDK/Sms_Send.asp?CorpID=#{SMS_ID}&LoginName=#{SMS_NAME}&passwd=#{SMS_PWD}&send_no=#{phone}&msg=#{message}"`
  #   end
  #   res
  # end

  def send_token!(message)
#    raise "系统已向您的手机发送过验证码，请勿频繁重复操作。" if self.invalid_date?
    if self.can_send?
      if RACK_ENV == "production"
        res = `curl "http://tui3.com/api/send/?k=bcaab9a8896135cda9b3e8f347948c5e&r=json&p=2&t=#{self.phone}&c=#{message}"`
        err_code = JSON.parse(res)["err_code"]
        raise "发送失败，请检查您输入的手机号是否正确。" unless err_code == 0
      end
      self.sent_at = Time.current
      self.message = message
      self.save!
    end
  end

  def self.validate(phone, token, purpose, account_id=nil)
    if ShortMessage.where(phone: phone, token: token, purpose: purpose, account_id: account_id).first.present?
      true
    else
      false
    end
  end

  def self.checkout(phone, token, purpose, account_id=nil)
    if account_id
      phone_token = ShortMessage.where(phone: phone, token: token, purpose: purpose, account_id: account_id).first
    else
      phone_token = ShortMessage.where(phone: phone, token: token, purpose: purpose).first
    end
    phone_token
  end

  def invalid_date?
    return false if id.nil?
    case purpose
    when PURPOSE["注册验证码"]
      valid = self.sent_at + REGISTER_TOKEN_VALID > Time.current 
    when PURPOSE["找回密码验证码"]
      valid = self.sent_at + FORGET_TOKEN_VALID > Time.current 
    when PURPOSE["登录验证码"]
      valid = self.sent_at + LOGIN_TOKEN_VALID > Time.current 
    else
      valid = false
    end
    valid
  end
  
  def self.checkout_judge(phone, token, purpose, account_id=nil)
    phone_token = ShortMessage.where(phone: phone, token: token, purpose: purpose, account_id: account_id).first
    phone_token = nil unless phone_token || phone_token.invalid_date?
    phone_token
  end

  def can_send?
    self.id.nil? || !(self.invalid_date?)
  end

  def self.make_token
    prng = Random.new(Random.new_seed)
    str = ''
    1.upto(6) do |i|
      str += prng.rand(0..9).to_s
    end
    str
  end

end
