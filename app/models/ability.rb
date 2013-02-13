class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :golfer
      can :read, [Course, Hole, Solution]
      can :create, Solution
    else #guest
      can :read, Course
      can :read, Hole
      can :read, Solution
      can :read, TestCase
      can :create, Solution
    end
  end
end
