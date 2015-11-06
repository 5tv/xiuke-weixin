class Rule
  TAG = ["剧情", "演员", "制作", "剧志"]
  # TAGGET should be a table
  TARGET = ['Post', 'Reply', 'Comment', 'Like', 'Share']
  ACTION = ['create', 'read', 'update', 'delete']

  # the interface supported for any controller's use
  def self.add_score_detail(account_id, serie_id, object, action)
    begin
      #流氓订阅
      # unless Follow.exists?(account_id: account_id, followable_type: 'Serie', followable_id: serie_id)
      #   Follow.create(account_id: account_id, followable_type: 'Serie', followable_id: serie_id)
      # end

      limitscore = Score.scorelimit(account_id, serie_id)
      if @temp_score = Score.where(account_id: account_id, serie_id: serie_id).first
        tempscore = @temp_score.tempscore
      else
        tempscore = 0
      end

      score, version = Rule.score_constant(account_id, serie_id, object, action)
      if tempscore < limitscore 
        ScoreDetail.checkin_scoredetail(account_id, serie_id, version, object, action, score)
      else
        false
      end
    rescue => e
    end
  end

  # def self.permission_judge(account_id, serie_id, tag, object, action)
  #   levels = Rule.which_level(account_id, serie_id)
  #   # target should be the name of the table needed to be operated
  #   target = object.class.to_s
  #   case action
  #   when 'create'
  #     levels >= PERMISSION[tag][target][action]
  #   when 'update'
  #     current_account.id == object.account_id ? levels >= PERMISSION[tag][target][action] : false
  #   when 'read'
  #     levels >= PERMISSION[tag][target][action]
  #   when 'delete'
  #     current_account.id == object.account_id ? levels >= PERMISSION[tag][target][action] : false
  #   end
  # end

  def self.which_level(account_id, serie_id)
    scores = Rule.get_serie_score(account_id, serie_id)
    for i in 0..LEVEL_ARRAY.length-1
      if i != LEVEL_ARRAY.length-1
        if (scores >= LEVEL_ARRAY[i] && scores < LEVEL_ARRAY[i+1])
          return i
        end
      else return scores >= LEVEL_ARRAY.last ? i : nil
      end
    end
  end

  def self.get_serie_score (account_id, serie_id)
    if scores = Score.where(account_id: account_id, serie_id: serie_id).first
      scores.totalscore if scores.present?
    else
      0
    end
  end

  def self.score_constant(account_id, serie_id, object, action)
    follow_obj =  Follow.where(account_id: account_id, followable_id: serie_id).first
    if follow_obj
      user_follow_alias = "following_score"
    else
      user_follow_alias = "score"
    end
    case object.class.name
    when "Like"
      if object.liked == nil
        score, version = SCORE[user_follow_alias]["like"].last.values
      elsif object.liked == true
        score, version = SCORE[user_follow_alias]["dig"].last.values
      elsif object.liked == false
        score, version = SCORE[user_follow_alias]["bury"].last.values
      end
    when "Post"
      score, version = SCORE[user_follow_alias]["post"].last.values
    when "Reply"
      score, version = SCORE[user_follow_alias]["reply"].last.values
    when "Comment"
      score, version = SCORE[user_follow_alias]["comment"].last.values
    when "Share"
      score, version = SCORE[user_follow_alias]["share"].last.values
    end
    return score, version
  end

  # permission.yml
  def self.allow_action(account_id, serie_id, obj_class_name, action_name, tag='default')
    user_level = self.which_level(account_id, serie_id)

    limit_level = PERMISSION[obj_class_name][tag][action_name]
    return user_level >= limit_level
  end

end