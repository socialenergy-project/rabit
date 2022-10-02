# frozen_string_literal: true

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

    if user.has_role? "admin"
      can :manage, :all
      cannot :manage, DrEvent
      can %i[read create], DrEvent

      can [:schedule, :edit, :update, :destroy], DrEvent do |dr_event|
        dr_event.created? || dr_event.ready?
      end

      can [:activate], DrEvent, &:ready?

      can [:cancel], DrEvent, &:active?
    else
      # cannot :index, User
      cannot :manage, :all

      can %i[index read create], DrEvent, user_id: user.id

      can [:schedule, :edit, :update, :destroy], DrEvent do |dr_event|
        dr_event.user_id == user.id && (dr_event.created? || dr_event.ready?)
      end

      can [:activate], DrEvent do |a|
        a.user_id == user.id && a.ready?
      end

      can [:cancel], DrEvent do |a|
        a.user_id == user.id && a.active?
      end

      can :read, ConsumerCategory

      can :read, Consumer, users: { id: user.id } # .includes(:users), ['users.id' => user.id]

      can :manage, EccType, consumer: { users: { id: user.id } }
      can :create, EccType

      can :manage, EccType, consumer: { users: { id: user.id } }
      can :create, EccType

      can :read, DrAction, consumer: { users: { id: user.id } }

      can :read, DataPoint, consumer: { users: { id: user.id } }

      # can :read, Message, user_id: user.id

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
