class ScoreDetail < ActiveRecord::Base
  belongs_to :account
  scope :total, -> { where(:created_at => ((Time.now - 3.hour).to_date + 3.hour).to_s(:db)..((Time.now - 3.hour).to_date + 1.day + 3.hour).to_s(:db)).sum(:scoregot) }

  after_create do
    Score.checkin_score(self.account_id, self.serie_id, self.scoregot)
  end

  def self.checkin_scoredetail(account_id, serie_id, tag, object, action, scoregot)
    ScoreDetail.create(account_id: account_id, serie_id: serie_id, object_type: object.class.to_s, object_id: object.id, action: action, tag: tag, scoregot: scoregot)
  end

end
