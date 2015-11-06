class VideoTranscodingStatus < ActiveRecord::Base
  belongs_to :video
  F360_STATUS = {'转码中' => 2, '压字幕中' => 4, '转码完成' => 6, 's3上传中' => 8, 's3_上传完成' => 10, '七牛上传中' => 12, '七牛上传完成' => 14}
  F540_STATUS = {'转码中' => 2, '压字幕中' => 4, '转码完成' => 6, 's3上传中' => 8, 's3_上传完成' => 10, '七牛上传中' => 12, '七牛上传完成' => 14}
end
