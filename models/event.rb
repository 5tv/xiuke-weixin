class Event < ActiveRecord::Base
  acts_as_cached

  mount_uploader :cover, ImageUploader
  belongs_to :account
  belongs_to :serie
  has_many :replies, :as => :replyable, :dependent => :destroy
  has_many :event_accounts
  belongs_to :operator, class_name: "Account", foreign_key: "operator_id"

  validates_presence_of :title, :description, :end_at, :start_at, :serie_id
  
  scope :online, -> { where(series_status: Serie::STATUS['online']) }

  before_create do
    self.series_status = self.serie.status if self.serie != nil
  end

  before_save do
    self.operator_id = self.account_id
  end

  after_create do
    Node.create!(serie_id: self.serie_id, account_id: self.account_id, nodeable_id: self.id, nodeable_type: self.class.to_s)
  end

  after_update do
    self.node.update!(updated_at: self.updated_at, series_status: self.series_status)
  end

  after_save do
    self.node.update(replies_count: self.replies_count)if replies_count_changed?
  end

  def with_virtual_attr
    self.attributes.merge({cover: self.cover.url})
  end

end
