class AccountSerie < ActiveRecord::Base
  acts_as_cached
  # include Redis::Search
  belongs_to :account
  belongs_to :serie, :counter_cache => true
  belongs_to :operator, class_name: "Account", foreign_key: "operator_id"

  ROLE = {"admin" => 1, "operator" => 3, "member" => 5}
  scope :online, -> { where(series_status: Serie::STATUS['online']) }
  scope :undeleted, ->{where(deleted: false)}
  validates_presence_of     :account_id


  before_create do
    self.series_status = self.serie.status
    self.operator_id = self.account_id unless self.operator_id.present?
  end

  after_update do
    if online_changed?
      if self.online == true
        self.serie.update(onlines_count: self.serie.onlines_count + 1) if self.serie.present?
      else
        self.serie.update(onlines_count: self.serie.onlines_count - 1) if self.serie.present?
      end
    end

    if deleted_changed?
      if self.deleted == true
        SerieRelatedId.where(serie_id: self.serie_id).first.atomic_remove(:account_series, self.id) rescue true 
      end
    end

  end

  after_create do
    SerieRelatedId.find_or_create_by(serie_id: self.serie_id).atomic_append(:account_series, self.id) rescue true    
  end

  after_destroy do
    SerieRelatedId.where(serie_id: self.serie_id).first.atomic_remove(:account_series, self.id) rescue true 
  end

  after_save do
    if self.serie_id.present?
      APP_CACHE.delete self.serie.ids_cache_key('account_serie')
    end
  end

  def with_base_account_info
    self.attributes.merge({name: self.account.name, avatar: self.account.profile_image_url.x200.url})
  end

  def account_name
    self.account.name rescue '未知用户'
  end

  def serie_name
    self.serie.title rescue '未知系列'
  end

  def account_autograph
    self.account.autograph rescue '暂无签名'
  end

  def with_virtual_attr
   self.attributes.merge!({
    :serie => self.serie.with_virtual_attr
    })
  end

  def with_virtual_attr_for_api
    self.attributes.merge({
      'account' => self.account.with_virtual_attr_for_api
      })
  end

  def with_virtual_attr_for_api_v2
    self.attributes.merge({
      'account' => self.account.name
      })
  end
end
