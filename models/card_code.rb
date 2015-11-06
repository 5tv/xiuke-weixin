class CardCode < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_item
  belongs_to :serie

  STATUS = {'新的' => 0, '已发出' => 1, '已兑换' => 2, '删除' => 3}
  def status_text
    STATUS.key(self.status) 
  end
end
