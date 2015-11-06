class VideoEffectiveSharePerson < ActiveRecord::Base
  belongs_to :serie, :counter_cache => true
  belongs_to :video, :counter_cache => true
end
