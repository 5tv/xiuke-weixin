class Lottery < ActiveRecord::Base
  STATUS = {'未上线' => 0, '已经上线' => 1, '已被抽走' => 2, '用户信息已提交' => 3, '短信通知成功' => 4}
  LEVEL = {'乐视超级电视70吋' => 1, '乐视超级电视60吋' => 2, '七v电视盒子' => 3, '去哪网30元酒店红包' => 4, '易快修汽车大礼包' => 5,'京东周林频谱旗舰店30元代金券' => 6, '没有中奖额^_^' => 7}
  has_one :lottery_address
  class << self
    def store
      WEIXIN_CACHE.fetch :weixin_lottery_store do
        []
      end
    end

    def store=(v)
      WEIXIN_CACHE.write :weixin_lottery_store, v
    end

    def counter
      WEIXIN_CACHE.fetch :weixin_counter do
        0
      end
    end

    def counter=(v)
      WEIXIN_CACHE.write :weixin_counter, v
    end

    def l_count
      WEIXIN_CACHE.fetch :weixin_l_count do
        0
      end
    end

    def l_count=(v)
      WEIXIN_CACHE.write :weixin_l_count, v
    end

    def l_time
      WEIXIN_CACHE.fetch :weixin_l_time do
        Time.now.to_i
      end
    end

    def l_time=(v)
      WEIXIN_CACHE.write :weixin_l_time, v
    end

    def draw 
      self.check
      temp = self.store.sample
      arr_temp = self.store - [temp]
      if arr_temp.present? and arr_temp.is_a? Array
        self.store= arr_temp
      end
      temp
    end

  end


  def self.check
    if self.store.size == 200
      hours = (Time.now.to_i - self.l_time)/3600.0
      count = (((self.l_count)/(hours))*24).to_i
      LotteryCreate.perform_async(count)
    else
      if Time.now.to_i  - self.l_time < 24.hours 
      elsif 24.hours < Time.now.to_i - self.l_time < 48.hours
        # ids = Lottery.where(level: 2, status: [0,1]).ids
        # if ids.count == 0
        #   id = Lottery.where(level: 1, status: 0).first
        # else
        #   id = ids.sample
        # end
        # if id.present? and !self.store.include?(id)
        #   Lottery.find(id).update(status: Lottery::STATUS['已经上线'])
        #   temp_arr = self.store + [id]
        #   temp_arr.uniq!
        #   self.store = temp_arr if temp_arr.is_a? Array
        # end
      else
        self.reset
      end 
    end
  end

  def self.update
    ids = Lottery.where(status: Lottery::STATUS['已经上线']).ids
    count = ids.count
    ids = ids.sample(count)
    if ids.present? and ids.is_a?(Array)
      temp_arr = self.store + ids
      temp_arr.uniq!
      self.store = temp_arr if temp_arr.is_a? Array
    end
    self.l_count = self.store.count
    self.l_time = Time.now.to_i
  end

  def self.reset
    list1 = Lottery.where(status: Lottery::STATUS['已经上线'], level: [3,4,5,6]).ids.sample(1300)
    list2 = Lottery.where(status: Lottery::STATUS['已经上线'], level: 7).ids.sample(8700)
    list = list1 + list2
    if list.present? and list.is_a? Array
      if list.count > 200
        self.store = list
      else
        temp = 300 - list.count
        temp.times do 
          Lottery.create(status: 1, level: 7)
        end
        list1 = Lottery.where(status: Lottery::STATUS['已经上线'], level: [3,4,5,6]).ids.sample(1300)
        list2 = Lottery.where(status: Lottery::STATUS['已经上线'], level: 7).ids.sample(8700)
        list = list1 + list2
        self.store = list if list.present? and list.is_a? Array
      end
    end
    self.l_count = list.count
    self.l_time = Time.now.to_i
  end

end
