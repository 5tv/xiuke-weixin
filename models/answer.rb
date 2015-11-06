class Answer < ActiveRecord::Base
  acts_as_cached
  
  belongs_to :question
  belongs_to :questionnaire, class_name: 'Post'

end
