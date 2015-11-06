class OperationRecord < ActiveRecord::Base
	validates_presence_of :operation_recordable_id, :operation_recordable_type, :attribute_name
	belongs_to :operation_recordable, polymorphic: true
end
