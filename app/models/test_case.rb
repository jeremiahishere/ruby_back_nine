class TestCase < ActiveRecord::Base
  belongs_to :hole

  validates_presence_of :setup
  validates_presence_of :expected_output

  # TODO
  # validate :expected_output_matches_sample_solution
  # def expected_output_matches_sample_solution
  #     
  # end

  scope :active, lambda { where(:active => true) }
  scope :samples, lambda { where(:sample => true) }
end
