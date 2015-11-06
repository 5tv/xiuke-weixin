class Score < ActiveRecord::Base
  belongs_to :account
  belongs_to :serie
  SCORE_LIMIT = {'CommonUser' => 100, 'FollowThisUser' => 150}
  # before_update do
  #   self.tempscore
  # end

  def self.checkin_score(account_id,serie_id,scoregot)
    if @score = Score.where(account_id: account_id, serie_id: serie_id).first
      ## validate the value of tempscore, tempscore located in today's time range unchaged or set to zero
      time_range = ((Time.now - 3.hour).to_date + 3.hour).to_s(:db)..((Time.now - 3.hour).to_date + 1.day + 3.hour).to_s(:db)
      if time_range.cover?(@score.updated_at) 
        temp = @score.tempscore
      else
        temp = 0 
        @score.update(tempscore: 0)
      end
      score = @score.totalscore
      @score.update(totalscore: score + scoregot, tempscore: temp + scoregot) if (temp + scoregot) < self.scorelimit(account_id,serie_id)
    else 
      Score.create(account_id: account_id, serie_id: serie_id, totalscore: scoregot, tempscore: scoregot)
    end
  end

  def self.scorelimit(account_id,serie_id)
    Follow.exists?(account_id: account_id, followable_type: 'Serie', followable_id: serie_id) ? SCORE_LIMIT['FollowThisUser'] : SCORE_LIMIT['CommonUser'] 
  end

  def with_virtual_attr_for_api
    temp = self.attributes
    temp.delete('tempscore')
    temp.merge!({
      'account' => self.account.with_virtual_attr_for_api,
      'level' => Rule.which_level(self.account_id, self.serie_id),
      'created_at' => self.created_at.utc,
      'updated_at' => self.updated_at.utc
      })
  end

end
