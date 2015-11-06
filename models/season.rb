class Season < ActiveRecord::Base
  belongs_to :serie
  has_many :videos, :dependent => :destroy
  
  has_one :product, as: :product_for
  attr_accessor :is_has_product

  def real_title
    self.serie.title + " 第#{self.episode}季"
  end
end
