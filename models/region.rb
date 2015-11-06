# encoding: utf-8
class Region < ActiveRecord::Base
  belongs_to :parent, foreign_key: :parent_id, class_name: 'Region'
  has_many :childrens, foreign_key: :parent_id, class_name: 'Region'

  validates :name, presence: true
  validates :parent_id, presence: true

  def self.roots
    where(parent_id: 0)
  end

  def self.siblings(arg)
    if arg.is_a?(User)
       where(parent_id: arg.user_detail.province_id)
    elsif arg.is_a?(Program)
       where(parent_id: arg.program_detail.province_id)
    end
  end

end