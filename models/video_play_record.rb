class VideoPlayRecord < ActiveRecord::Base
  PLATFORM = {'IOS' => 1, 'Android' => 2, 'Web' => 3, 'WeChat' => 4, 'Other' => 5}
  ACTION = ['click_play', 'click_pause', 'scroll_play', 'click_next', 'auto_next', 'stop', 'serie_click']

end
