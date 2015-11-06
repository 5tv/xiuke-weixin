class SelectedSerie < ActiveRecord::Base

  belongs_to :serie
  scope :online, ->{where(status: STATUS['online'])}
  scope :p_and_o, ->{where(status: [STATUS['online'], STATUS['pending']])}
  STATUS = {'pending' => 0, 'online' => 1, 'offline' => 2}
  mount_uploader :web_image, ImageUploader
  
  def with_virtual_attr
    self.attributes.merge({
      'web_image' => self.web_image.url
    })
  end

  def with_virtual_attr_for_api
    self.attributes.merge({
      'web_image' => self.web_image.url,
      'serie' => self.serie.with_virtual_attr_for_api,
      'videos' => self.serie.videos.online.order("episode DESC").map(&:with_virtual_attr_for_api_v2)
    })
  end

  def self.cache_the_recommended
    m = cache_read_the_recommended

    #临时解决方案
    video_ids = [8154, 7981, 7978, 3993, 4904, 4833]
    m.merge({
      'web_image' => '',
      'serie' => Serie.find(m['serie_id']).with_virtual_attr_for_api,
      'videos' => video_ids.map{|id| Video.find(id)}.map{|a| a.with_virtual_attr_for_api_v2.merge({
        # 'posts' => []
        'posts'=> a.posts.toy.order("created_at DESC").first(2).map(&:with_virtual_attr_for_api_v2)
        })}
      })
    # m.merge({
    #   'web_image' => '',
    #   'serie' => Serie.find(m['serie_id']).with_virtual_attr_for_api,
    #   'videos' => Serie.find(m['serie_id']).videos.online.order("episode DESC").map{|a| a.with_virtual_attr_for_api_v2.merge({
    #     'posts'=> a.feed_posts.toy.order("created_at DESC").first(2).map(&:with_virtual_attr_for_api_v2)})}
    #   })
  end

  def self.cache_read_the_recommended
    JSON.parse(API_CACHE.get('api:selectedseries:therecommened'))
  end

  def self.cache_write_the_recommended(id)
    API_CACHE.set('api:selectedseries:therecommened', SelectedSerie.find(id).with_virtual_attr.to_json)
  end

end
