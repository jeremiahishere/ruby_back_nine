class Hole < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  belongs_to :course

  has_many :test_cases, :class_name => 'TestCase', :dependent => :destroy
  accepts_nested_attributes_for :test_cases, :allow_destroy => true
  has_many :solutions, :dependent => :destroy
  accepts_nested_attributes_for :solutions, :allow_destroy => true
  
  validates_presence_of :name 
  validates_presence_of :maximum_execution_time

  # not usable until the user system is setup
  # validates_presence_of :creator_id

  scope :active, lambda { where(:active => true) }

  def sample_test_case
    test_cases.samples.first 
  end

  def sample_solution
    solutions.samples.first
  end
end
