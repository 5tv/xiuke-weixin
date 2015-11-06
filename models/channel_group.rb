class ChannelGroup < ActiveRecord::Base
  has_many :videos, -> { order('order_in_group ASC') }
  belongs_to :xlabel_list

  before_save do 
    ChannelGroup.clear_cached_latest
  end

  def save_to_video(channel_group_videos)
    new_video_ids = channel_group_videos.split(',').map(&:to_i)
    old_video_ids = self.videos.map(&:id)
    Video.update_channel_group(new_video_ids, self.id, self.xlabel_list_id)
    Video.remove_channel_group(old_video_ids - new_video_ids, self.xlabel_list_id)
  end
  
  def with_virtual_attr_for_api
    self.attributes.merge({
      xlabel_list: self.xlabel_list.with_virtual_attr_for_api,
      videos: self.videos.order('order_in_group asc').map(&:with_virtual_attr_for_api_v2)
      })
  end

  def with_virtual_attr_for_api_v3
    self.attributes.merge({
      xlabel_list: self.xlabel_list.with_virtual_attr_for_api,
      videos: self.videos.order('order_in_group asc').map(&:attr_for_search)
      })
  end

  def self.cached_latest_key
    'channel_groups/latest'
  end

  def self.clear_cached_latest
    APP_CACHE.delete(self.cached_latest_key)
  end

  def self.fetch_cached_latest
    APP_CACHE.fetch(self.cached_latest_key) do 
      ChannelGroup.order('online_at desc, display_order asc').group_by{|a| a.online_at.strftime("%Y/%m/%d")}.values.first.map(&:with_virtual_attr_for_api_v3).to_json
    end
  end

end
