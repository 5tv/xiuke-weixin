class AccountElection < ActiveRecord::Base
  belongs_to :account
  belongs_to :election
  has_many :votes, as: :voteable
  has_many :replies, :as => :replyable, :dependent => :destroy
  mount_uploader :cover, ImageUploader
  mount_uploader :video, VideoUploader
  mount_uploader :skin_photo, ImageUploader
  mount_uploader :makeup_photo, ImageUploader
  mount_uploader :story_pic1, ImageUploader
  mount_uploader :story_pic2, ImageUploader
  mount_uploader :story_pic3, ImageUploader
  mount_uploader :story_pic4, ImageUploader

  STATUS = {'上线供选择' => 1, '审核中' => 0}
  
  scope :online, -> { where(status: STATUS['上线供选择']) }

  before_create do
    self.series_status = self.serie.status
  end

  def with_virtual_attr
    self.attributes.merge(
      :makeup_photo => {:url => self.makeup_photo.url}, 
      :skin_photo => {:url => self.skin_photo.url}, 
      :cover => {:url => self.cover.url}, 
      :url => self.get_url, 
      :story_pic1 => {:url => self.story_pic1.url}, 
      :story_pic2 => {:url => self.story_pic2.url}, 
      :story_pic3 => {:url => self.story_pic3.url}, 
      :story_pic4 => {:url => self.story_pic4.url}, 
      :short_description => "#{self.description[0,20] if self.description.present?}..."
    )
  end

  def uniq_key
    self.video.file.basename
  end

  def get_url
    if !self.url.present? || self.view_token_created_at < Time.now.utc - 1.hour
      if self.url_high
        @access_key = Qiniu::Config.settings[:access_key]
        @secret_key = Qiniu::Config.settings[:secret_key]
        @mac = Qiniu::Auth::Digest::Mac.new(@access_key, @secret_key)
        base_url = Qiniu::Rs.make_base_url(QiniuBucketURL[:video], self.url_high)
        get_policy = Qiniu::Rs::GetPolicy.new
        get_policy.Expires = 7200
        nurl = get_policy.make_request(base_url, @mac)

        @rs_cli = Qiniu::Rs::Client.new(@mac)

        self.update_attributes(:url => nurl, :view_token_created_at => Time.now.utc)

        code, res = @rs_cli.Stat(QiniuBucket[:video], self.url_high)
        if code == 200 
          self.update_attributes(:f540p_filesize => JSON.parse(res)["fsize"])
        end
      end
    end
    self.url
  end

  def get_cover
    if self.cover.file.file.present? && self.cover_token_created_at.present?
      if self.cover_token_created_at < Time.now.utc - 1.hour

        @access_key = Qiniu::Config.settings[:access_key]
        @secret_key = Qiniu::Config.settings[:secret_key]
        @mac = Qiniu::Auth::Digest::Mac.new(@access_key, @secret_key)
        base_url = Qiniu::Rs.make_base_url(QiniuBucketURL[:video], "video_#{self.id}_cover")
        get_policy = Qiniu::Rs::GetPolicy.new
        get_policy.Expires = 7200
        ncover = get_policy.make_request(base_url, @mac)

        self.write_uploader("cover", ncover)
        self.cover_token_created_at = Time.now.utc
        self.save
      end
    end
    self.cover.file.path.sub(/^.*public\/uploads/, "http://#{XIUKE_DN}/uploads")
  end
end
