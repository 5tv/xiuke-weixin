class Withdraw < ActiveRecord::Base
  acts_as_cached
  has_many :transactions, :as => :trade_for, :dependent => :destroy
  belongs_to :account
  belongs_to :income
  scope :success, ->{where(status: STATUS['pay_ok'])}
  scope :failure, ->{where(status: STATUS['refuse'])}
  scope :waiting, ->{where(status: STATUS['paying'])}
  PLATFORM = ['Alipay', 'Weixin']
  PLATFORM_T = {'Alipay' => '支付宝', 'Weixin' => '微信'}
  STATUS = {'paying' => 1, 'pay_ok' => 2, 'refuse' => 3}
  STATUS_T = {'处理中'=> 1, '处理完成'=> 2, '处理失败' => 3 }

  validates_presence_of     :account_id
  validates_presence_of     :income_id
  validates_presence_of     :money
  validates_presence_of     :status
  validates_presence_of     :third_account
  validates_presence_of     :platform

  attr_accessor :transaction_num

  after_create do
    # withdraw success
    if self.status == STATUS['paying']
      income = self.income
      old_money = income.money
      new_money = income.money - self.money

      income.money = new_money
      income.save!
#TODO
      income_change_log = income.income_change_logs.new
      income_change_log.before_num = old_money
      income_change_log.after_num = new_money
      income_change_log.change_by = self
      income_change_log.save!
    end
  end

  after_save do 
    if status_changed? && self.status == STATUS['pay_ok']
      transaction = self.transactions.new
      transaction.trade_num = self.transaction_num
      transaction.trade_type = "alipay"
      transaction.save!
    end
  end

  def status_text
    Withdraw::STATUS_T.key(self.status)
  end

end
