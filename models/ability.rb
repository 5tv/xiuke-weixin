class Ability
  include SimpleCancan::Ability
  def initialize(account)

    account ||= Account.new

    case account.role_num
    when Account::EN_ROLE['admin']
    	can :manage, :all
    when Account::EN_ROLE['pm_manager']

        is_pm_series         = Serie.unscoped.joins(:account_serie_pms).where("account_serie_pms.account_id = #{account.id}")
        is_pm_videos         = Video.unscoped.joins(serie: :account_serie_pms).where("account_serie_pms.account_id = #{account.id}")
    	is_pm_account_series = AccountSerie.joins(serie: :account_serie_pms).where("account_serie_pms.account_id = #{account.id}")
        
        can :read, Serie
        can :read, Video
    	can [:update, :destroy], is_pm_series
    	can [:update, :destroy], is_pm_videos
        can :read, AccountSerie
    	can [:create, :update, :destroy], is_pm_account_series
    	can [:create, :read], Article
    	can [:update, :destroy], Article.where(account_id:account.id)
    	can :manage, SelectedVideo
    	can :manage, ChannelGroup
    	can [:create, :read, :destroy], Barrage
    	can [:create, :read, :destroy], Topic
    	can :manage, XlabelList
    	can :manage, Platform
    	can [:create, :read, :update], PlatformStatistic
    	can :read, AccountVideo
    	can [:create, :read, :destroy], Post
    	can :manage, ArticlePlatform
    	can :manage, Node
    	can :manage, Term
    	can [:create, :read], SeriePlatformQrStat
    	can [:create, :read], SeriePlatformStatistic
    	can :read, AppDownloadInfo
    	can :read, SearchResult
        can :manage, SelectedSerie
        can :manage, StartupPic
        can :read, AccountSeriePm
    when Account::EN_ROLE['user']

        is_operator_series           = Serie.unscoped.joins(:account_series).where("account_series.account_id = #{account.id}").where("account_series.role = #{AccountSerie::ROLE['operator']}")
        is_admin_series              = Serie.unscoped.joins(:account_series).where("account_series.account_id = #{account.id}").where("account_series.role = #{AccountSerie::ROLE['admin']}")
        is_operator_offline_series   = is_operator_series.where.not(status:Video::STATUS['已上线'])
        is_admin_offline_series      = is_admin_series.where.not(status:Video::STATUS['已上线'])
        
        is_operator_videos           = Video.joins(serie: :account_series).where("account_series.account_id = #{account.id}").where("account_series.role = #{AccountSerie::ROLE['operator']}")
        is_admin_videos              = Video.joins(serie: :account_series).where("account_series.account_id = #{account.id}").where("account_series.role = #{AccountSerie::ROLE['admin']}")
        is_operator_offline_videos   = is_operator_videos.where.not(status:Video::STATUS['已上线'])
        is_admin_offline_videos      = is_admin_videos.where.not(status:Video::STATUS['已上线'])

        is_pm_topics                 = Topic.joins(video: {serie: :account_serie_pms}).where("account_serie_pms.account_id = #{account.id}")

        is_operator_accont_series                      = AccountSerie.where(serie_id:is_operator_series.pluck(:id))
        is_admin_account_series                        = AccountSerie.where(serie_id:is_admin_series.pluck(:id))
        is_operator_account_series_except_serie_admin  = is_operator_accont_series.where.not(role:AccountSerie::ROLE['admin'])
        is_admin_account_series_except_serie_admin     = is_admin_account_series.where.not(role:AccountSerie::ROLE['admin'])

        can [:create, :read], Serie
		can [:update, :destroy], is_operator_offline_series
        can [:update, :destroy], is_admin_offline_series
        can :read, Video
        can [:update, :destroy], is_operator_offline_videos
        can [:update, :destroy], is_admin_offline_videos
        can :read, AccountSerie
        can [:update, :destroy], is_operator_account_series_except_serie_admin
        can :update, is_admin_account_series
        can :destroy, is_admin_account_series_except_serie_admin
        can :read, Topic
        can :destroy, is_pm_topics
        can :read, SelectedVideo
		can :read, ChannelGroup
		can [:create, :read], Barrage
		can [:create, :read], Post
		can :update, Post.where(account_id:account.id)
		can :read, Node
    	can :read, Term
    when Account::EN_ROLE['tourist']
    	can :read, Serie
    	can :read, Video
    	can :read, AccountSerie
    	can :read, Article
    	can :read, SelectedVideo
    	can :read, ChannelGroup
    	can :read, Barrage
    	can :read, Topic
    	can :read, XlabelList
    	can :read, Post
    	can :read, Node
    	can :read, Term
    end
  end
end
