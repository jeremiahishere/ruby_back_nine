class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :golfer
      can :read, [Course, Hole, Solution]
      can :create, Solution
    else
      can :read, Course
      can :read, Hole
    end
  end
end
