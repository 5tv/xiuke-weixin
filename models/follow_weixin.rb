class WeixinFollow < ActiveRecord::Base
  acts_as_cached

  belongs_to :account
  belongs_to :followable, :polymorphic => true, :counter_cache => true
  validates_uniqueness_of :account_id, scope: [:followable_id, :followable_type]
  scope :serie_follows , -> {where(followable_type: "Serie")}

  FOLLOWABLE_TYPES = ['Serie']

  after_save do
    self.update_second_level_cache
    self.account.ids_cache_content_delete('follows')
    api_key_delete
  end

  def self.serie_followed(serie, account)
    if Follow.where(account_id: account, followable_id: serie, followable_type: 'Serie').first
      '不想追了'
    else
      '追'
    end
  end

  def self.is_follow?(serie, account)
    if Follow.where(account_id: account, followable_id: serie, followable_type: 'Serie').first
      return true
    else
      return false
    end
  end

end
