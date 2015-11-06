class Election < ActiveRecord::Base
  acts_as_cached

  belongs_to :account
  belongs_to :serie
  has_many :replies, :as => :replyable, :dependent => :destroy
  has_many :account_elections, class_name: "AccountElection"
  mount_uploader :cover, ImageUploader

  scope :online, -> { where(series_status: Serie::STATUS['online']) }

  before_create do
    self.series_status = self.serie.status
  end

  after_create do
    Node.create!(serie_id: self.serie_id, account_id: self.account_id, nodeable_id: self.id, nodeable_type: self.class.to_s)    

    # Activity.create(account_id: self.account_id, serie_id: self.serie_id, 
    #   activityable_type: "Election", activityable_id: self.id, action_name: "create", 
    #   memo: "#{self.account.name}创建了投票#{self.title}")
  end

  after_update do
    self.node.update!(updated_at: self.updated_at, series_status: self.series_status)
  end

  after_save do
    self.node.update(replies_count: self.replies_count)if replies_count_changed?
    # if serie = Serie.where(id: self.serie_id).first
    #   if self.end_at.present? && serie.next_end_of_activityable.end_at.present?
    #     if !serie.next_end_of_activityable.present? || (serie.next_end_of_activityable.present? && (serie.next_end_of_activityable.end_at > self.end_at))
    #       serie.next_end_of_activityable = self
    #       serie.save
    #     end
    #   end
    # end
  end

  def with_virtual_attr
    self.attributes.merge({cover: self.cover.url})
  end

  def composers
    if account_ids = self.account_elections.map {|ae| ae.account_id}
      Account.where(id: account_ids)
    end
  end
end
