class AppSlider < ActiveRecord::Base
  belongs_to :video
  belongs_to :serie
  belongs_to :account
  mount_uploader :cover, SliderImageUploader
  
  scope :online, ->{where(status: STATUS['online'])}
  scope :issued, ->{where(status: STATUS['issued'])}

  STATUS = {'pending' => 0, 'online' => 1, 'offline' => 2, 'issued' => 3}
  PRC_STATUS = {'等待' => 0, '已推荐' => 1, '删除' => 2, '已发布' => 3}

  def with_virtual_attr_for_api
    self.attributes.merge({
      cover: cover_hash
      })
  end

  def cover_hash
    {
      origin: self.cover.url,
      x1080: self.cover.x1080.url,
      x720: self.cover.x720.url,
      x640: self.cover.x640.url
    }
  end

  def cache_value
    with_virtual_attr_for_api.to_json
  end

  def self.cache_get_sliders
    if API_CACHE.exists('apicache/appsliders/display_order')
      arr = [1,2,3,4,5]
      API_CACHE.hmget('apicache/appsliders/display_order', *arr)
    else
      @sliders = AppSlider.online.where(display_order: [1,2,3,4,5])
      if @sliders.count == 5
        temp = {}
        @sliders.each {|s| temp[s.display_order] = s.cache_value}
        API_CACHE.hmset('apicache/appsliders/display_order', *temp)
      end
      arr = [1,2,3,4,5]
      API_CACHE.hmget('apicache/appsliders/display_order', *arr)
    end
  end

  def self.cache_write_sliders(array)
    if array.count == 5 and array.is_a?(Array)
      temp = {}
      array.each {|s| temp[s.display_order] = s.cache_value}
      API_CACHE.hmset('apicache/appsliders/display_order', *temp)
    end
  end

end
