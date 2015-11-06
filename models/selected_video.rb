class SelectedVideo < ActiveRecord::Base
  attr_accessor :skip_callbacks
  belongs_to :account
  scope :online, ->{where(status: STATUS['online'])}
  STATUS = {'pending' => 0, 'online' => 1, 'offline' => 2}
  TIME_DEFAULT = ['早午餐', '下午茶', '下班喽', '在路上', '洗洗睡吧', '周末福利']
  mount_uploader :icon, BaseImageUploader

  before_save do
    begin
      if self.status_changed? 
        if self.status == STATUS['online']
          SelectedVideo.cache_api_ids_write(self.id)
          SelectedVideo.cache_write_selected_video(self.id)
        elsif self.status == STATUS['offline']
          SelectedVideo.cache_api_ids_delete(self.id)
          SelectedVideo.cache_delete_selected_video(self.id)
          if self.job_id.present?
            AutoIssue.delete_job_with_id(self.job_id, 'SelectedVideo')
          end
        end
      end

      unless self.skip_callbacks
        if issue_time_changed? and self.issue_time.present?
          if self.job_id.present?
            AutoIssue.delete_job_with_id(self.job_id, 'AutoIssue')
          end
          t = AutoIssue.perform_at(self.issue_time.to_i, self.id, 'SelectedVideo')
          self.job_id = t
        end
      end
    rescue => e
      STDERR.puts e
      STDERR.puts e.backtrace.join("\n")
      true
    end

  end 

  after_save do 
    if video_ids_changed?
      SelectedVideo.cache_del_selected_video_videos_json(self.id)
    end
  end

  def with_virtual_attr_for_api
    self.attributes.merge({
      'icon' => self.icon.url,
      'day' => self.issue_time? ? self.issue_time.in_time_zone('Beijing').day : self.created_at.in_time_zone('Beijing').day,
      'month' => self.issue_time? ? self.issue_time.in_time_zone('Beijing').month : self.created_at.in_time_zone('Beijing').month,
      'hour' => self.issue_time? ? self.issue_time.in_time_zone('Beijing').hour : self.created_at.in_time_zone('Beijing').hour
    })
  end

  def beijing_issue_time
    self.issue_time.in_time_zone('Beijing').strftime('%Y-%m-%d %H:%M:%S') rescue ''
  end

  def job_id=(value)
    API_CACHE.set("api:selectedvideos:#{self.id}:job_id", value)
  end

  def job_id
    API_CACHE.get("api:selectedvideos:#{self.id}:job_id")
  end

  def self.cache_api_ids_read
    # len = API_CACHE.llen('api:selectedvideos:online:ids')
    # len = len - 1 < 0 ? 0 : len - 1 
    result = API_CACHE.lrange('api:selectedvideos:online:ids', 0, -1)
    unless result.present?
      SelectedVideo.where(status:STATUS['online']).all.each do |sv|
        SelectedVideo.cache_api_ids_write(sv.id)
        SelectedVideo.cache_write_selected_video(sv.id)
      end
      result = API_CACHE.lrange('api:selectedvideos:online:ids', 0, -1)
    end
    result
    # API_CACHE.smembers("api:selectedvideos:online:ids")
  end

  def self.cache_api_ids_write(value)
    if value.is_a?(Integer)
      API_CACHE.rpush("api:selectedvideos:online:ids", value)
      # API_CACHE.sadd("api:selectedvideos:online:ids", value)
    end
  end

  def self.cache_api_ids_delete(value)
    if value.is_a?(Integer)
      API_CACHE.lrem("api:selectedvideos:online:ids", 1, value)
      # API_CACHE.srem("api:selectedvideos:online:ids", value)
    end
  end

  def self.cache_get_selected_video(ids)
    API_CACHE.hmget('api:selectedvideos', *ids)
  end

  def self.cache_write_selected_video(id)
    API_CACHE.hmset('api:selectedvideos', id, SelectedVideo.find(id).with_virtual_attr_for_api.to_json)
  end

  def self.cache_delete_selected_video(id)
    API_CACHE.hdel('api:selectedvideos', id)
  end

  def self.cache_write_selected_video_videos_json(id, api_version = 'v2')
    if api_version == 'v2'
      API_CACHE.hmset('api:selectedvideos:videos:json:v2', id, SelectedVideo.find(id).video_ids.compact.map{|id| Video.find(id).with_virtual_attr_for_api_v2}.to_json)
    else
      API_CACHE.hmset('api:selectedvideos:videos:json:v3', id, SelectedVideo.find(id).video_ids.compact.map{|id| Video.find(id).attr_for_search}.to_json)
    end
  end

  def self.cache_read_selected_video_videos_json(ids, api_version = 'v2')
    if api_version == 'v2'
      API_CACHE.hmget('api:selectedvideos:videos:json:v2', *ids)
    else
      API_CACHE.hmget('api:selectedvideos:videos:json:v3', *ids)
    end
  end

  def self.cache_del_selected_video_videos_json(id, api_version = 'v2')
    if api_version == 'v2'
      API_CACHE.hdel('api:selectedvideos:videos:json:v2', id)
    else
      API_CACHE.hdel('api:selectedvideos:videos:json:v3', id)
    end
  end

  def self.page_title
    API_CACHE.get('api:selectedvideos:page_title') || '马上看'
  end

  def self.page_title=(value)
    API_CACHE.set('api:selectedvideos:page_title', value)
  end

  def self.cache_videos(ids=[], api_version = 'v2')
    # ids = self.cache_api_ids_read.sort.reverse
    svs = self.cache_get_selected_video(ids).compact.map{|a| JSON.parse(a)}
    svs.map do |sv|
      if !API_CACHE.hkeys("api:selectedvideos:videos:json:#{api_version}").include?(sv['id'].to_s)
        self.cache_write_selected_video_videos_json(sv['id'].to_i, api_version)
      end 
      sv.merge({
        'videos' => JSON.parse(self.cache_read_selected_video_videos_json([sv['id']], api_version)[0])
        })
    end
  end


end
