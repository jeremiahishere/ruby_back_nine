require Rails.root.to_s + "/lib/solution_runner"

class Solution < ActiveRecord::Base
  belongs_to :hole
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :code

  scope :samples, lambda { where(:sample => true) }

  def ran?
    ran_at.nil?
  end

  def check_solution
    runner = ::SolutionRunner.new(self)
    output = runner.run

    # use the total cases and passed cases to determine success
    total_cases = hole.test_cases.active.count
    output_errors = ""
    passed_cases = 0
    output.each_pair do |test_case, output|
      if output.has_key?(:error)
        output_errors += output[:error] + "\n"
      elsif test_case.expected_output == output[:value]
        passed_cases += 1
      end 
    end

    # why does this need self?
    self.ran_at = Time.now
    self.success = (passed_cases == total_cases)
    self.code_output = output.inspect
    self.display_output = "#{passed_cases}/#{total_cases} cases passed\n#{output_errors}"
    self.display_output
    self.score = code.gsub(/\s/, '').size
    self.save!
  end
end
