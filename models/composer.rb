class Composer < ActiveRecord::Base
  acts_as_cached
  belongs_to :account

  belongs_to :province, foreign_key: :province_id, class_name: 'Region'
  belongs_to :city, foreign_key: :city_id, class_name: 'Region'
  
  validates_presence_of   :realname, :intro, :phone, :email

end
