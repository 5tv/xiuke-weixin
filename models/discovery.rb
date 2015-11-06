class Discovery < ActiveRecord::Base
  belongs_to :account
  belongs_to :serie
  belongs_to :video

  scope :online, ->{where(status: STATUS['online'])}
  scope :issued, ->{where(status: STATUS['issued'])}

  CHANNEL = ['get', 'serial', 'sports']
  STATUS = {'pending' => 0, 'online' => 1, 'offline' => 2, 'issued' => 3}
  PRC_STATUS = {'未被推荐' => 0, '已推荐' => 1, '删除' => 2, '已发布' => 3}
  PRC_CHANNEL = {'Get' => 'get', '神剧院' => 'serial', '运动场' => 'sports'}

  mount_uploader :cover, ImageUploader

  after_save do
    if title_changed?
      self.video.update(secondary_title: self.title)
    end
  end

  def with_virtual_attr_for_api
    self.attributes.merge({
      'cover' => video_cover,
      'title' => video_title,
      'serie_title' => self.serie.title,
      'video' => self.video.with_virtual_attr_for_api_v2,
      'account_series' => self.serie.account_series.order('display_order asc').map(&:with_virtual_attr_for_api_v2)
      })
  end

  def video_cover
    if self.cover?
      {
        origin: self.cover.url
      }
    else
      {
        origin: self.video.cover.x300.url
      }
    end
  end

  def video_title
    if self.title?
      self.title
    else
      self.video.title
    end
  end

  def cache_value
    with_virtual_attr_for_api.to_json
  end

  def self.cache_get_discoveries(channel)
    key = "apicache/discoveries/#{channel}/display_order"
    arr = [1,2,3,4]
    if API_CACHE.exists(key)
      API_CACHE.hmget(key, *arr)
    else
      @discoveries = Discovery.online.where(channel: channel, display_order: arr).to_a
      if @discoveries.count == 4
        temp = {}
        @discoveries.each {|s| temp[s.display_order] = s.cache_value}
        API_CACHE.hmset(key, *temp)
      end
      API_CACHE.hmget(key, *arr)
    end
  end

  def self.cache_write_discoveries(channel, array)
    if CHANNEL.include?(channel)
      key = "apicache/discoveries/#{channel}/display_order"
      if array.count == 4 and array.is_a?(Array)
        temp = {}
        array.each {|s| temp[s.display_order] = s.cache_value}
        API_CACHE.hmset(key, *temp)
      end
    end
  end


end
