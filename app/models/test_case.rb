class TestCase < ActiveRecord::Base
  belongs_to :hole

  validates_presence_of :hole
  validates_presence_of :setup
  validates_presence_of :expected_output

  scope :active, lambda { where(:active => true) }
end
