class HomeTop < ActiveRecord::Base
  has_many :pictures, :as => :pictureable, :dependent => :destroy
end
