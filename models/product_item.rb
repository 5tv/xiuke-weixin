class ProductItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :currency
  has_many :consumes
  has_many :card_codes
  TYPE = {'Default' => 0, 'Iphone' => 1, 'Android' => 2, '兑换码1' => 3, '兑换码2' => 4, '兑换码3' => 5}
  STATUS = {'有效' => 1, '删除' => 0}
  scope :no_delete, -> { where(status: STATUS['有效'])}

  def account_id
    serie_id = self.product.serie_id
    owner_serie = OwnerSerie.find_by_serie_id(serie_id)
    return owner_serie.account_id
  end

  def type_text
    TYPE.key(self.use_type)
  end

  def title
    "#{self.type_text}(#{self.currency_num}#{self.currency.name})"
  end
end
