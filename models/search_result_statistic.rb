class SearchResultStatistic < ActiveRecord::Base
  validates_uniqueness_of :content
  include Redis::Search
  redis_search_index(
    :title_field => :content,
    # :alias_field => :description,
    # :prefix_search_enable => true,
    :score_field => :count,
    # :condition_fields => [:account_id, :status],
    # :ext_fields => [:description, :composers],
    :class_name => 'SearchResultStatistic'
  )
end
