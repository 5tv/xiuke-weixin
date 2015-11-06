class AndroidVersion < ActiveRecord::Base
  belongs_to :api_version
  has_one :app_address, :as => :versionable, :dependent => :destroy
  scope :running, ->{where(status: STATUS['正在使用中'])}
  scope :incoming, ->{where(status: STATUS['即将发布'])}
  scope :dropped, ->{where(status: STATUS['已弃用'])}
  accepts_nested_attributes_for :app_address
  STATUS = {'已弃用' => 0 ,'正在使用中' => 1, '即将发布' => 2}
  def to_human
    "#{self.major}.#{self.minor}.#{self.revision}"
  end
end
