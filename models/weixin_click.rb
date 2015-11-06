class WeixinClick < ActiveRecord::Base
  belongs_to :account
  belongs_to :video
  belongs_to :weixin_supporter
  validates_uniqueness_of :weixin_supporter_id, scope: [:account_id, :video_id]
  MESSAGE_ONE = [
    '视频赞啊，顶一个！',
    '笑死老子了，必须给你顶一个！',
    '就不信顶不到你，啊哈哈哈',
    '千好万好不如一个顶好',
    '这视频是要笑死我的节奏么',
    '专业帮顶20年！',
    '顶个，祝你新的一年工作生活都能达到顶峰',
    '帮顶，抽到大奖请我吃饭！',
    '顶到你飞起，这样真的大丈夫？',
    '平生不敢轻言语，一叫顶起万花开',
    '好看就要顶起来',
    '你问我爱你有多深，顶起代表我的心~',
    '大家顶才是真的顶',
    '赞是亲顶是爱，多顶几次是关怀',
    '送你一首我最喜欢的歌：“顶顶顶顶顶顶…”',
    '老娘出马，一个顶俩',
    '新年抽个奖不容易啊！顶你',
    '已顶，红包赶紧发来',
    '这个必须顶，顶你一年都happy',
    '好基友果断顶，不解释',
    '视频哪里转发出来的？有意思'
  ]
  MESSAGE_ZERO = [
    '我顶你个肺呀',
    '哎呀，手滑没顶到',
    '亲，你该减肥了，我实在顶不住了',
    '红包抢的有点手软，过完年再顶你',
    '咦？什么情况？',
    '视频太好笑勒，笑岔了气顶不上勒',
    '这么好玩的视频哪分享的？我先去下载，你等等哈',
    '这。。。顶你不就拉低我中奖率了嘛',
    '我顶！哎呀，用力过猛，顶到2016年了',
    '新年没收到你红包，感觉不会再爱了',
    '就不给你顶，就不给你顶'
  ]
  after_create do
    begin
      if self.points != 0
        @weixin_statistic = WeixinStatistic.where(account_id: self.account_id, video_id: self.video_id).first
        count = @weixin_statistic.clicks_count + self.points
        @weixin_statistic.update(clicks_count: count)        
      end
    rescue
      false
    end
  end
end
