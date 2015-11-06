class Rate < ActiveRecord::Base
  acts_as_cached

  belongs_to :account
  belongs_to :serie, :counter_cache => true

  validates_uniqueness_of :account_id, scope: [:serie_id]

  after_save do
    if rates = self.serie.rates
      self.serie.update(rate_score: rates.sum(:score) / (rates.count * 1.0))
    end
  end

end
