class Bill < ActiveRecord::Base
  acts_as_cached
  belongs_to :account
  belongs_to :serie
  belongs_to :check_account, class_name: "Account", foreign_key: "check_by"
  has_many :refuse_reasons, as: :refuse_for, dependent: :destroy
  has_many :transactions, :as => :trade_for, :dependent => :destroy
  has_many :income_change_logs, :as => :change_by, :dependent => :destroy
  has_many :refuse_reasons, as: :refuse_for, dependent: :destroy

  attr_accessor :refuse_reason
  attr_accessor :transaction_num

  validates_presence_of   :account_id, :serie_id, :category_num, :money, :status
  validates_numericality_of :money

  STATUS = {'checking' => 0, 'paying' => 1, 'pay_ok' => 2, 'refuse' => 3}
  STATUS_T = {'审核中' => 0, '付款中'=> 1, '付款完成'=> 2, '审核失败' => 3 }
  CATEGORY_T = {'保底制作费' => 0, '版权权利费' => 1, '广告业务分成' => 2, '发行业务分成' => 3}

  after_save do
    if status_changed? && self.status == STATUS['refuse']
      refuse_reason = self.refuse_reasons.new
      refuse_reason.reason = self.refuse_reason
      refuse_reason.save!
    end

    # complete bill
    if status_changed? && self.status == STATUS['pay_ok']
      transaction = self.transactions.new
      transaction.trade_num = self.transaction_num
      transaction.trade_type = "alipay"
      transaction.save!

      serie = self.serie
      income = serie.income
      
      old_money = income.money
      new_money = income.money + self.money

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

  def category 
    Bill::CATEGORY_T.key(self.category_num) if self.has_attribute?('category_num')
  end

end
