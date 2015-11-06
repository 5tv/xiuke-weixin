class SerieRelatedId < ActiveRecord::Base
  include AtomicArrays
  validates_uniqueness_of :serie_id
end
