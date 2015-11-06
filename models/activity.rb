class Activity < ActiveRecord::Base
  acts_as_cached
  belongs_to :activity, :polymorphic => true
  belongs_to :account
  belongs_to :serie

  scope :displayable, -> { where(level: 0) }
  scope :online, -> { where(series_status: Serie::STATUS['online']) }

  ACTIVITY_TYPE = ["Event", "Serie", "Topic", "Video", "AccountVideo", "Share", "Like"]

  before_create do
    self.series_status = self.serie.status
  end

end
