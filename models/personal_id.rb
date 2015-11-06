class PersonalId < ActiveRecord::Base
  include AtomicArrays
  validates_uniqueness_of :account_id


  def cache_get(set)
    get_temp = API_CACHE.smembers("/personal_ids/#{self.id}/#{set.to_s}")
    if get_temp.present?
      get_temp
    else
      arr_temp = self.send(set)
      arr_temp.each do |a|  
        API_CACHE.sadd("/personal_ids/#{self.id}/#{set.to_s}", a)
      end
      API_CACHE.smembers("/personal_ids/#{self.id}/#{set.to_s}")
    end
  end

  def cache_exist?(set)
    API_CACHE.exists("/personal_ids/#{self.id}/#{set.to_s}")
  end

  def cache_add(set, value)
    if value.is_a?(Integer)
      API_CACHE.sadd("/personal_ids/#{self.id}/#{set.to_s}", value)
    end
  end

  def cache_remove(set, value)
    if value.is_a?(Integer)
      API_CACHE.srem("/personal_ids/#{self.id}/#{set.to_s}", value)
    end
  end

  def atomic_append(field, value)
    if cache_get(field).include?(value.to_s)
      true
    else
      super(field, value)
      if cache_exist?(field)
        cache_add(field, value)
      else
        cache_get(field)
        cache_add(field, value)
      end rescue true
    end
  end

  def atomic_remove(field, value)
    super(field, value)
    if cache_exist?(field)
      cache_remove(field, value)
    else
      cache_get(field)
      cache_remove(field, value)
    end rescue true
  end

  def with_virtual_attr_for_api
    self.attributes
  end


  def self.cache_find_or_create(account_id, set)
    if API_CACHE.exists("/personal_ids/#{account_id}/#{set.to_s}")
      API_CACHE.smembers("/personal_ids/#{account_id}/#{set.to_s}")
    else
      # p = PersonalId.where(account_id: account_id).first
    end
  end

  def self.cache_get_with_id(account_id)
    like_videos = API_CACHE.smembers("/personal_ids/#{account_id}/like_videos")
    purchase_videos = API_CACHE.smembers("/personal_ids/#{account_id}/purchase_videos")
    follow_series = API_CACHE.smembers("/personal_ids/#{account_id}/follow_series")
    {account_id: account_id, like_videos: like_videos, purchase_videos: purchase_videos, follow_series: follow_series}
  end


  


end
