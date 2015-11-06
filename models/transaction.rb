class Transaction < ActiveRecord::Base
  belongs_to :order
  belongs_to :trade_for, :polymorphic => true
  TRADE_FOR_TYPE=['Widthdraw', 'Order']
  TRADE = {'Withdraw' => '取现', 'Order' => '订单支付'}
  PLATFORM = ['Alipay', 'Weixin']
  PLATFORM_T = {'Alipay' => '支付宝', 'Weixin' => '微信'}
  

end
