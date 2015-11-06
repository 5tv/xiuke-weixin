class InviteDetail < ActiveRecord::Base

  belongs_to :account
  belongs_to :post
  belongs_to :ask_people, :foreign_key => :send_to, :class_name => 'Account'
  has_one :message, :as => :messageable, :dependent => :destroy
  validates_presence_of     :account_id
  validates_presence_of     :post_id
  validates_presence_of     :send_to

  after_create do 
    Message.create(account_id: self.account_id, receiver_id: self.send_to, messageable_type: 'InviteDetail', messageable_id: self.id)
  end

  def self.add(invite_params)
    InviteDetail.create!(invite_params)
  end

  def self.remove(invite_params)
    @invite_detail = InviteDetail.where(account_id: invite_params[:account_id], 
                                        send_to: invite_params[:send_to], 
                                        post_id: invite_params[:post_id]).first
    if @invite_detail
      @invite_detail.destroy
    end
  end
end
