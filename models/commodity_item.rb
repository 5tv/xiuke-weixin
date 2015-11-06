class CommodityItem < ActiveRecord::Base
  belongs_to :commodity
  has_many :orders
  DISCOUNT_TYPE = {'打折' => 'percent_off', '优惠金额' => 'price_off'} 

end
