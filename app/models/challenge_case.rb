class ChallengeCase < ActiveRecord::Base
  belongs_to :challenge

  validates_presence_of :challenge
  validates_presence_of :setup
  validates_presence_of :expected_output

  scope :active, lambda { where(:active => true) }
end
