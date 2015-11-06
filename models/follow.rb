class Follow < ActiveRecord::Base
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

  after_create do
    PersonalId.find_or_create_by(account_id: self.account_id).atomic_append(:follow_series, self.followable_id) rescue true
  end

  after_destroy do
    PersonalId.where(account_id: self.account_id).first.atomic_remove(:follow_series, self.likeable_id) rescue true
  end


  def api_key_delete
    APP_CACHE.delete "/api/follows/#{self.account_id}"
  end

  def with_virtual_attr
    self.attributes.merge(followable: self.followable)
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

  def with_virtual_attr_for_api
    self.attributes.merge({
      'account' => self.account.with_virtual_attr_for_api
      })
  end

  def virtual_attr_with_followable
    followable = eval("#{self.followable_type}.find(#{self.followable_id})") rescue nil
    self.attributes.merge({
      'account' => self.account.with_virtual_attr_for_api,
      self.followable_type.downcase => followable
      })
  end

end
