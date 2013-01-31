class Challenge < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :cases, :class_name => 'ChallengeCase'
  has_many :solutions
  
  validates_presence_of :name 
  validates_presence_of :maximum_execution_time
  validates_presence_of :creator_id

  scope :active, lambda { where(:active => true) }

end
