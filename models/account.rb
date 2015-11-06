require 'openssl'
require 'base64'

class Account < ActiveRecord::Base
  include Redis::Search
  attr_accessor :password, :password_confirmation
  acts_as_cached
  acts_as_taggable_on :skills

  mount_uploader :profile_image_url, AvatarUploader
  mount_uploader :cover, ImageUploader
  has_many :events
  has_many :event_accounts, :dependent => :destroy
  has_many :series, class_name: 'Serie'
  has_many :likes
  has_many :complaints
  has_many :complainteds, as: :complaint_for, :class_name => 'Complaint', dependent: :destroy
  has_one  :api_key, :dependent => :destroy
  has_one  :composer, :dependent => :destroy
  has_many :account_series, class_name: "AccountSerie", dependent: :destroy
  has_many :activities
  # has_many :account_videos, class_name: 'AccountVideo'
  has_many :shares
  has_many :devices
  has_many :short_messages, class_name: 'ShortMessage'
  has_many :follows
  has_many :account_videos, class_name: 'AccountVideo'
  has_many :rates
  has_many :posts, ->{where(deleted: false)}
  has_many :questions
  has_many :answers
  has_many :score_details
  has_many :scores
  has_many :invite_details
  has_many :send_messages, :foreign_key => :account_id, :class_name => 'Message'
  has_many :readed_messages, ->{where(viewed: true)}, :foreign_key => :receiver_id, :class_name => 'Message'
  has_many :get_messages, ->{where(viewed: false)}, :foreign_key => :receiver_id, :class_name => 'Message'
  has_many :send_notices, :foreign_key => :account_id, :class_name => 'Notice'
  has_many :get_notices, :foreign_key => :receiver_id, :class_name => 'Notice'

  has_many :sample_details
  has_many :receiver_samples, :foreign_key => :send_to, :class_name => 'SampleDetail'
  has_many :account_assets
  has_many :incomes
  has_many :agreements
  has_many :account_serie_pms
  has_many :pm_series, :through => :account_serie_pms,:source => :serie
  has_many :member_series, :through => :account_series, :source => :serie

  has_many :bills
  has_many :weixin_supporters

  has_many :account_specials
  has_many :banners
  has_many :invites

  has_many :videos
  has_many :articles
  has_many :article_platforms
  has_many :watch_records
  has_many :terms
  has_many :account_topics
  has_many :barrages
  accepts_nested_attributes_for :composer, :allow_destroy => true

  ROLE = {'管理员' => 5, '普通用户' => 20, '编辑' => 22, '游客' => 30} 
  EN_ROLE = {"admin" => 5, "user" => 20, 'pm_manager' => 22, 'tourist' => 30}
  ACL = {
          "update_ontop" => ['xiuker', 'pm_manager', 'admin', 'external_operation'],
          "update_post_type" => ['xiuker', 'pm_manager', 'admin', 'external_operation'],
          "video_list" => ['xiuker', 'pm_manager', 'admin'],
          "task_line" => ['xiuker', 'pm_manager', 'admin'],
          "recommend_line" => ['xiuker', 'pm_manager', 'admin']
        }

  SHARE_SECRET = "fenxiangmiyao1"

#  validates_presence_of     :email,                      :if => :native_login_required
  validates_presence_of     :name,                        :if => :native_login_required
  # validates_uniqueness_of   :name
  validates_format_of       :name,     :with => /\A(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]{2,20}\Z/i, :if => :native_login_required
  validates_presence_of     :password,                    :if => :native_login_required
  validates_presence_of     :password_confirmation,       :if => :native_login_required
  validates_length_of       :password, :within => 4..40,  :if => :native_login_required
  validates_confirmation_of :password,                    :if => :native_login_required
  validates_length_of       :email,    :within => 3..100, :allow_blank => true
  validates_uniqueness_of   :email,    :case_sensitive => false, :allow_blank => true
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true
  validates_format_of       :phone,    :with => /\A1\d{10}\z/, :allow_blank => true
  validates_uniqueness_of   :phone, :allow_blank => true
  validates_uniqueness_of   :weibo_uid, :allow_blank => true
  validates_uniqueness_of   :qq_uid, :allow_blank => true
  validates_uniqueness_of   :weixin_login_openid, :allow_blank => true
  # validates_uniqueness_of   :weixin_unionid, :allow_blank => true, :allow_nil => true

  validate :accounts_consistency

  redis_search_index(
    :title_field => :name,
    :ext_fields => [:id, :profile_image_url_to_hash],
    :alias_field => :email,
    # :prefix_search_enable => true,
    :class_name => 'Account'
  )

  # Callbacks
  before_save do
    if password_required
      encrypt_password
    end
    if self.name_changed? && self.name_change.first.present? && Account.exists?(:name => self.name.to_s)
      self.name = "#{self.name}#{rand(99999)}"
    end
    if self.autograph.blank?
      self.autograph = "追剧中，没空写签名。"
    end
  end

  after_save do
    APP_CACHE.delete ids_cache_key('follows')
    self.account_series.map(&:serie).compact.each do |s|
      APP_CACHE.delete s.ids_cache_key('account_serie')
    end
  end
  
  after_create do
    self.create_api_key
    Currency.all.each do |currency|
      self.account_assets.create(:currency_id => currency.id, :num => 0)
    end

    Serie.default_follow.each do |serie|
      follow = self.follows.new()
      follow.followable = serie
      follow.save!
    end
  end

  def is_pm_series_ids
    self.account_serie_pms.pluck(:serie_id)
  end

  def is_member_series_ids
    self.account_series.pluck(:serie_id)
  end

  #ROLE = {'管理员' => 5, '普通用户' => 20, '编辑' => 22, '游客' => 30} 
  def related_series_ids
    case self.role_num 
    when ROLE['管理员']
      Serie.pluck(:id)
    when ROLE['编辑']
      self.is_pm_series_ids
    when ROLE['普通用户']
      self.is_member_series_ids
    else
      []
    end
  end

  def related_series
    case self.role_num 
    when ROLE['管理员']
      Serie.unscoped
    when ROLE['编辑']
      Serie.unscoped.where(id:self.is_pm_series_ids)
    when ROLE['普通用户']
      Serie.unscoped.where(id:self.is_member_series_ids)
    else
      []
    end  
  end

  def role 
    Account::EN_ROLE.key(self.role_num) if self.has_attribute?('role_num')
  end

  def pusher_channel
    Digest::MD5.hexdigest("account_#{self.id}")
  end

  def duty_in_serie(serie_id)
    @account_series = self.account_series.where(serie_id: serie_id)
    @account_series.present? ? @account_series.first.duty : ""
  end

  def sample_video_in_serie(serie_id)
    if serie = Serie.find(serie_id)
      if self.duty_in_serie(serie_id) != ""
        sample_videos = serie.videos.sample
      else
        sample_video_ids = self.receiver_samples.collect{|v| v.video_id}
        sample_videos = serie.videos.sample.where(['videos.id in (?)', sample_video_ids])
      end
    end
    sample_videos
  end

  def with_virtual_attr
    temp = self.attributes
    temp.delete('crypted_password')
    # temp.merge!(:skill_list => self.skill_list.join(','), 
    #   "profile_image_url" => self.profile_image_url.url.sub(/http:\/tp/, 'http://tp'),
    #   :cover => self.cover.url,
    #   :follows => self.follows.map {|f| f.with_virtual_attr },
    #   :account_series => self.account_series.map {|as| as.with_virtual_attr }
    #   )
    # if self.composer
    #   temp.merge!(:city => self.composer.try(:city), :province => self.composer.try(:province))
    # end
    temp
  end

  def profile_image_url_hash
    {
      x300: self.profile_image_url.x300.url,
      x200: self.profile_image_url.x200.url,
      x150: self.profile_image_url.x150.url,
      x100: self.profile_image_url.x100.url, 
      x50: self.profile_image_url.x50.url,
      x25: self.profile_image_url.x25.url,
    }
  end

  def with_virtual_attr_for_api
    tmp = self.attributes
    ['complaints_count', 'activate_token_created_at', 'updated_at', 'created_at', 'crypted_password', 'role_bak', 'role_num', 'phone_activated', 'email_activated', 'xiuke2_id', 'events_count', 'event_accounts_count'].each do |item|
      tmp.delete(item) 
    end

    tmp.merge!(
      :skill_list => self.skill_list.join(','),
      'profile_image_url' => self.profile_image_url.url.sub(/http:\/tp/, 'http://tp'),
      'profile_image_urls' => self.profile_image_url_hash,
      :cover => self.cover.url,
      :tourist => self.role_num == 30,
      :is_master_serie_ids => AccountSerie.where(account_id:self.id).pluck(:serie_id),
      :is_operator_serie_ids => AccountSerie.where(role:AccountSerie::ROLE['operator']).where(account_id:self.id).pluck(:serie_id)
      )
    if self.cache_content_of('composer').present?
      tmp.merge!(:city => self.cache_content_of('composer').first.try(:city), :province => self.cache_content_of('composer').first.try(:province))
    end
    tmp
  end

  ##
  # used for redis cache
  def ids_cache_key(relation)
    "#{CACHE_PREFIX}/account/#{self.id}/#{relation}/ids"
  end

  def ids_cache_content(relation)
    APP_CACHE.fetch(ids_cache_key(relation)) do
      relation.camelize.singularize.constantize.where(account_id: self.id).ids
    end
  end

  def cache_content_of(relation)
    ids_cache_content(relation).map do |id|
      relation.camelize.singularize.constantize.find(id)
    end.compact
  end

  def ids_cache_content_delete(relation)
     APP_CACHE.delete(ids_cache_key(relation))
  end

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(password, email=nil, phone=nil)
    if email.present?
      account = Account.where(:email => email).first
      return {:error_messages => "该email没有注册过5tv", :account => nil} unless account.present?
    elsif phone.present?
      account = Account.where(:phone => phone).first
      return {:error_messages => "该电话号码没有注册过5tv", :account => nil} unless account.present?
    else
      return {:error_message => "请输入账户名密码", :account => nil}
    end
    return {:error_messages => "账户名或密码不正确", :account => nil} unless account.has_password?(password)
    {error_messages: nil, account: account}
  end

  def send_forget_password_email
    pw_verification_token = self.api_key.g_pw_verification_token
    Mailgun.send_html_message("5tv找回密码邮件！", self.email,
                                "<h2>亲爱的#{self.name}：</h2>
                                <p>
                                   　　<strong>重置密码链接：<a href=\"http://5tv.com/user_reset_password?i=#{pw_verification_token}\">\"http://5tv.com/user_reset_password?i=#{pw_verification_token}\"</a>（如果您的邮箱不支持链接点击，请将以上链接复制到浏览器地址栏来访问）</strong></p>

                                <p>　　<strong>该链接仅在1小时内点击有效。</strong></p>

                                <p><strong>感谢您的使用！</strong></p>

                                <p><strong>网站访问 http://5tv.com　</strong><br/>
                                <strong>此邮件由系统自动发送，请勿回复。</strong></p>"
    )
    self.api_key.update_attribute(:pw_verification_token_created_at, Time.now)
  end
  
  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def admin?
    EN_ROLE[self.role] == ROLE['管理员']
  end
  
  def user?
    EN_ROLE[self.role] == ROLE['普通用户']
  end

  def access_token
    self.api_key.access_token
  end

  def encrypt_cookie_value
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = APP_CONFIG['session_secret']
    Base64.encode64(cipher.update("#{id} #{crypted_password}") + cipher.final)
  end
  
  def self.decrypt_cookie_value(encrypted_value)
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = APP_CONFIG['session_secret']
    plain = decipher.update(Base64.decode64(encrypted_value)) + decipher.final
    id, crypted_password = plain.split
    return id.to_i, crypted_password
  rescue
    return 0, ""
  end

  def self.validate_cookie(encrypted_value)
    user_id, crypted_password = decrypt_cookie_value(encrypted_value)
    if (account = Account.find(user_id)) && (account.crypted_password = crypted_password)
      return account
    end
  end
  
  def follow_date(serie_id)
    follow = self.follows.where(followable_type: "Serie", followable_id: serie_id).first
    follow_time = (Time.now - follow.created_at).to_i
    follow_day = follow_time/(60*60*24)
    offset_day = follow_time%(60*60*24) > 0 ? 1 : 0
    return (follow_day + offset_day)
  end

  def serie_post_count(serie_id)
    return self.posts.where(serie_id: serie_id).count
  end


  def can_play_video? video
    has_special?(video) || !video.is_need_special?
  end

  def has_special? special_for_obj
    @specials = self.cache_content_of('account_specials')
    case special_for_obj.class.name
    when "Serie"
      has_serie_special?(special_for_obj)
    when "Season"
      has_season_special?(special_for_obj) || has_special?(special_for_obj.serie)
    when "Video"
      if special_for_obj.serie.is_has_season
        has_season_special?(special_for_obj) || has_special?(special_for_obj.season)
      else
        has_season_special?(special_for_obj) || has_special?(special_for_obj.serie)
      end
    else
      false
    end
  end

  def can_access?(action_name)
    return ACL[action_name].include?(self.role)
  end

  def share_sign(video_id)
    account_id = "5tv_#{self.id}"
    video_id = video_id.to_s
    share_token = SHARE_SECRET
    param_array = [account_id, video_id, share_token]
    sign = Digest::SHA256.hexdigest( param_array.sort.join)
    return sign
  end

  def personal_ids
    personal_id = PersonalId.where(account_id: self.id).first
    if personal_id.present?
      if personal_id.like_videos.present?
        temp = personal_id.like_videos.map do |id|
          {video_id: id, serie_id: Video.find(id).serie_id}
        end
      else
        temp = []
      end
      personal_id.attributes.merge({'like_video_series' => temp})
    else
      {}
    end
  end

  def attr_for_search
    attrs = Account.redis_search_options.values.flatten
    attrs.pop(4)
    res = {}
    attrs.each do |attr|
      res.merge!({attr => eval("self.#{attr.to_s}")})
    end
    res
  end

  def profile_image_url_to_hash
    {
      origin: self.profile_image_url.url,
      x300: self.profile_image_url.x300.url,
      x200: self.profile_image_url.x200.url,
      x150: self.profile_image_url.x150.url,
      x100: self.profile_image_url.x100.url,
      x50: self.profile_image_url.x50.url,
      x25: self.profile_image_url.x25.url
    }
  end

  private

  def has_serie_special? serie
    return @specials.reject{|s| (s.special_for_type != "Serie") || (s.special_for_id != serie.id)}.size > 0
  end

  def has_season_special? season
    return @specials.reject{|s| (s.special_for_type != "Season") || (s.special_for_id != season.id)}.size > 0
  end

  def has_video_special? video
    return @specials.reject{|s| (s.special_for_type != "Video") || (s.special_for_id != video.id)}.size > 0
  end

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) unless password.blank?
  end

  def password_required
    crypted_password.blank? || password.present?
  end
  
  def native_login_required
    weibo_uid.blank? && qq_uid.blank? && password_required && weixin_login_openid.blank? && weixin_unionid.blank? && role_num != Account::ROLE['游客']
  end

  def email_with_native_login_required
    email.present? && weibo_uid.blank? && qq_uid.blank? && password_required && weixin_login_openid.blank? && weixin_unionid.blank?
  end

  def phone_with_native_login_required
    phone.present? && weibo_uid.blank? && qq_uid.blank? && password_required && weixin_login_openid.blank? && weixin_unionid.blank?
  end

  def accounts_consistency
    attributes = [phone, email, weibo_uid, qq_uid, weixin_login_openid, weixin_unionid]
    result = attributes.select do |attr|
      !attr.nil?
    end

    if result.count < 1  and self.role_num != Account::ROLE['游客']
      errors.add(:base, "options consistency error")
    end
  end

  def self.is_manager?(current_account)
    ['admin', 'xiuker', 'pm_manager'].include?(current_account.role)
  end

  def self.hot_composers
    series = Video.top_last_week(30).map(&:serie)
    account_series = series.map{ |serie| serie.account_series.order(:display_order).first }
    account_series.map(&:account).uniq
  end

end
