class Agreement < ActiveRecord::Base
  mount_uploader :download_link, AgreementUploader
  belongs_to :account
  belongs_to :serie

  STATUS = {'生效' => 0, '删除' => 1}
  TYPE = {'业务合同' => 0}

  scope :online, -> { where(status: STATUS['生效']) }

  def agreement_type
    TYPE.key(self.agreement_type_num) if self.has_attribute?('agreement_type_num')
  end
end
