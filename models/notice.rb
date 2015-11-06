class Notice < ActiveRecord::Base
  belongs_to :account, :foreign_key => :account_id
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => 'Account'
  belongs_to :noticeable, :polymorphic => true
  # scope :has_been_read 
  NOTICE_DEVICE = ['iPhone', 'iPad' , 'Andriod_Phone', 'Andriod_Tablet', 'Common_Phone', 'Common_Tablet', 'Computer', 'Special']
  SEND_TYPE_HASH = {'iPhone' => 1, 'iPad' => 1, 'Andriod_Phone' => 2, 'Andriod_Tablet' => 2, 'Common_Phone' => nil, 'Common_Tablet' => nil, 'Computer' => 3, 'Special' => 0}
  ##
  # sms : send short message to phone; apns : send messages to apple apps; c2dm : send messages to andriod apps
  SEND_TYPE = ['SMS', 'APNS', 'C2DM', 'Web']
  SEND_STATUS = ['Waiting', 'Sending', 'Send Success']
  MENTIONABLE_TYPE = {'帖子' => 'Post', '回复' => 'Reply', '评论' => 'Comment', '视频' => 'Video'}
  MESSAGE_ACTION_TYPE = {'提到' => 'Mention', '喜欢' => 'Like', '评论' => 'Comment', '回复' => 'Reply', '更新' => 'Video', '邀请' => 'InviteDetail'}

  scope :web, -> { where(send_type_id: SEND_TYPE.index('Web')) }
  scope :unviewed, -> { where(viewed: false) }

  after_create do
    if self.noticeable_type == 'Message'
      if self.send_type_id == SEND_TYPE.index('Web')
        # Pusher[self.receiver.pusher_channel].trigger('message_event', {
        #   message: self.show_message,
        #   link: link 
        # })
        self.update(send_type_id: SEND_TYPE.index('Web'), send_status: SEND_STATUS.index('Send Success'), last_send_at: Time.now)   
      end
    elsif self.noticeable_type == 'Serie'
      # Pusher[self.receiver.pusher_channel].trigger('message_event', {
      #   message: self.show_serie,
      #   link: link
      # })
    end
  end

  def link
    self.noticeable_type == 'Message' ? "/messages" : "/series/show?id=#{self.noticeable_id}" 
  end

  def show_message
    if self.noticeable_type == "Serie"
      return self.show_serie
    end
    case self.noticeable.messageable_type
    when 'Mention'
      obj = MENTIONABLE_TYPE.key( self.noticeable.messageable.mentionable_type)
      "#{self.account.name}在#{obj}中#{Notice::MESSAGE_ACTION_TYPE.key(self.noticeable.messageable_type)}了你"
    when 'Like'
      obj = MENTIONABLE_TYPE.key( self.noticeable.messageable.likeable_type)
      "#{self.account.name}在#{obj}中#{Notice::MESSAGE_ACTION_TYPE.key(self.noticeable.messageable_type)}了你"
    when 'Comment'
      obj = MENTIONABLE_TYPE.key( 'Reply' )
      "#{self.account.name}在#{obj}中#{Notice::MESSAGE_ACTION_TYPE.key(self.noticeable.messageable_type)}了你"
    when 'Reply'
      obj = MENTIONABLE_TYPE.key( self.noticeable.messageable.replyable_type)
      "#{self.account.name}在#{obj}中#{Notice::MESSAGE_ACTION_TYPE.key(self.noticeable.messageable_type)}了你"
    when 'InviteDetail'
      obj = MENTIONABLE_TYPE.key('Post')
      "#{self.account.name}在#{obj}中#{Notice::MESSAGE_ACTION_TYPE.key(self.noticeable.messageable_type)}了你"
    when 'Video'
      video = self.noticeable.messageable
      "《#{video.serie.title}》系列更新至#{video.episode_or_type}"
    end
  end

  def show_serie
    "5tv官方出新系列了《#{self.noticeable.title}》"
  end

end
