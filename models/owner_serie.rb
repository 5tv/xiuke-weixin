class OwnerSerie < ActiveRecord::Base
  belongs_to :account
  belongs_to :serie
  belongs_to :income
end
