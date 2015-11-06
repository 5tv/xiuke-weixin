class Report < ActiveRecord::Base
  belongs_to :reportable, :polymorphic => true

  REPORTABLE_TYPE = ['Video', 'Topic', 'Reply', 'Comment','Account']
  REPORT_TYPE = {"举报" => 1,"建议" => 2}
end
