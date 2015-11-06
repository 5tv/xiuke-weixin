class Invite < ActiveRecord::Base
  belongs_to :account
  
  def already_use
    self.unused=false
    self.save
  end

  def self.code id
    "#{id}#{rand(10)}#{rand(10)}#{rand(10)}#{rand(10)}#{rand(10)}"
  end

  def self.create_account_serie i, a, serie
    self.transaction do
      AccountSerie.create({serie_id: i.serie_id, account_id: a.id, duty: i.duty, series_status:serie.id,operator_id:i.account_id})
      i.already_use
      notice_params={:email=>i.email,:serie_title=>serie.title,:duty=>i.duty}
      SendEmail.send_email_for_account_serie_notice(notice_params)
    end
  end
end
