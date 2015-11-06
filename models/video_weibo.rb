class VideoWeibo < ActiveRecord::Base

  has_many :video_weibo_comments

  validates_uniqueness_of :mid, :allow_nil => false

  def new_comments
    return @new_comments if @new_comments
    weiboid = self.mid
    since_id = self.max_cid.to_i
    comments_arr_total = []
    comments_arr = WeiboApi.get_comments({id: weiboid, since_id: since_id, count: 100})[:comments]
    while comments_arr.present?
      comments_arr_total += comments_arr
      since_id = comments_arr.map{|c| c[:id]}.max
      comments_arr = WeiboApi.get_comments({id: weiboid, since_id: since_id, count: 100})[:comments]
    end
    @new_comments = VideoWeiboComment.new_with_weibocomment_arr(comments_arr_total, self.id)
    return @new_comments
  end

end
