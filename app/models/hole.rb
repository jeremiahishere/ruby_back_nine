class Hole < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  belongs_to :course
  has_many :cases, :class_name => 'TestCase', :dependent => :destroy
  has_many :solutions, :dependent => :destroy
  
  validates_presence_of :name 
  validates_presence_of :maximum_execution_time

  # not usable until the user system is setup
  # validates_presence_of :creator_id

  scope :active, lambda { where(:active => true) }

end
