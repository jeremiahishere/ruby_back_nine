class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :golfer
      can :read, [Course, Hole, Solution, TestCase]
      can :create, Solution
    else #guest
      can :read, [Course, Hole, Solution, TestCase]
    end
  end
end