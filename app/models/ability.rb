class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    if user.has_role? 'admin'
      can :manage, :all
    else
      # cannot :index, User
      can :read, :all
      cannot :read, Consumer
      can :read, Consumer, users: {groups: {group_memberships: {user_id: user.id} }}
      can :read, Consumer, users: {id: user.id }
      # can [:select, :confirm], Clustering
      cannot :read, [User]
      can :show, User do |emp|
        user.id == emp.id
      end
      can :create, Scenario
      can :manage, Scenario do |scenario|
        user == scenario.user
      end
      can :create, ClScenario
      can :manage, ClScenario do |cl_scenario|
        user == cl_scenario.user
      end
    end

  end
end
