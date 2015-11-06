class AppAddress < ActiveRecord::Base
  belongs_to :versionable, :polymorphic => true
  has_many :app_download_infos
  mount_uploader :address, AppUploader
  TYPE = ["AndroidVersion", "IosVersion"]
  TYPE_X = {'安卓' => 'AndroidVersion', '苹果' => 'IosVersion'}
end
