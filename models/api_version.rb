class ApiVersion < ActiveRecord::Base
  has_many :android_versions
  has_many :ios_versions
  scope :running, ->{where(status: STATUS['正在使用中'])}
  scope :incoming, ->{where(status: STATUS['即将发布'])}
  scope :dropped, ->{where(status: STATUS['已弃用'])}
  STATUS = {'已弃用' => 0 ,'正在使用中' => 1, '即将发布' => 2}
  DEFAULT = 'v1'
  def to_human
    "#{self.major}.#{self.minor}.#{self.revision}"
  end

  def with_virtual_attr_for_api
    temp = {}
    if self.ios_versions.running.present?
      temp.merge!({
        ios: self.ios_versions.running.map(&:to_human)
        })
    end
    if self.android_versions.running.present?
      temp.merge!({
        android: self.android_versions.running.reverse.map do |android|
          android.app_address.present? ? url = "http://#{XIUKE_DN}/v1/app_downloads/show?id=#{android.app_address.id}"
            : url = "http://5tv.com"
          [android.to_human, url]
        end
        })
    end
    temp
  end

end
