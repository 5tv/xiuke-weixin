class Question < ActiveRecord::Base
  acts_as_cached
  
  belongs_to :questionnaire, :class_name => 'Post'
  mount_uploader :cover1, BaseImageUploader
  mount_uploader :cover2, BaseImageUploader
  mount_uploader :cover3, BaseImageUploader
  mount_uploader :cover4, BaseImageUploader
  mount_uploader :cover5, BaseImageUploader
  mount_uploader :cover6, BaseImageUploader

  EN_TYPE = ['SingleChoice', 'MultipleChoice', 'Text']
  EN_TO_CN_TYPE = {'SingleChoice' => '单选题', 'MultipleChoice' => '多选题', 'Text' => '填空题'}

  def options
    case self.question_type
    when 'SingleChoice', 'MultipleChoice'
      [option1, option2, option3, option4, option5, option6].compact
    else
      []
    end
  end


  def with_virtual_attr_for_api
    self.attributes.merge({
      'cover1' => self.cover1.url,
      'cover2' => self.cover2.url,
      'cover3' => self.cover3.url,
      'cover4' => self.cover4.url,
      'cover5' => self.cover5.url,
      'cover6' => self.cover6.url
    })
  end





end
