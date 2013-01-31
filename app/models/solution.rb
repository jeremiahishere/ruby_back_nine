class Solution < ActiveRecord::Base
  belongs_to :challenge
  belongs_to :user

  validates_presence_of :challenge_id
  validates_presence_of :user_id
  validates_presence_of :code

  def ran?
    ran_at.nil?
  end

  def check_solution
    runner = SolutionRunner.new(challenge, self)
    output = runner.run
    ran_at = Time.now

    # use the total cases and passed cases to determine success
    total_cases = challenge.cases.active.coutn
    passed_cases == 0
    output.each_pair do |challenge_case, value|
      if challenge_case.expected_output == value
        passed_cases++
      end 
    end

    success = (passed_cases == total_cases)
    code_output = output.inspect
    display_output = "#{passed_cases}/#{total_cases} cases passed"
    score = code.gsub(/\s/, '').size
    save
  end
end
