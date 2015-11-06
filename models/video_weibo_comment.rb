class VideoWeiboComment < ActiveRecord::Base
  
  belongs_to :video_weibo

  after_save do
    @account = Account.find_or_create_by(:weibo_uid => self.user_id) do |account|
      account.name = self.user_name
      account.role_num = Account::ROLE['普通用户']
      account.profile_url = "u/#{self.user_id}"
    end
    Post.create(account_id: 13738, title: self.text, body: self.text, post_type: Post::POST_TYPE['普通'], video_id: self.video_id, post_for_type: 'Video', post_for_id: self.video_id, source: '微博', serie_id: Video.find(self.video_id).serie_id)
  end

  def self.new_with_weibocomment_arr(arr, video_weibo_id)
    if arr.present? and arr.is_a?(Array)
      temp = []
      arr.sort_by!{|c| c[:id]}
      video_id = VideoWeibo.find(video_weibo_id).video_id
      arr.each do |c|
        temp << VideoWeiboComment.new(video_weibo_id: video_weibo_id, cid: c[:id].to_s, text: c[:text], user_name: c[:user][:name], profile_image_url: c[:user][:profile_image_url], user_id: c[:user][:idstr], video_id: video_id)
      end
      temp
    else
      []
    end
  end

  def self.multi_new_objects_save(arr)
    if arr.present? and arr.is_a?(Array)
      arr.each do |c_object|
        c_object.save!
      end
      temp_cid = arr.map{|o| o.cid.to_i}.max
      weibo = arr.last.video_weibo
      if Time.now - weibo.created_at >= 24.hours
        weibo.update(max_cid: temp_cid.to_s, last_updated_at: Time.now, expired: true)
      else
        weibo.update(max_cid: temp_cid.to_s, last_updated_at: Time.now)
      end
      true
    else
      false
    end
  end

end
