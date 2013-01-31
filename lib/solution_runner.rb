require 'timeout'

class SolutionRunner
  def initialize(challenge, solution)
    @challenges_cases = challenge.cases.active
    @solution = solution
  end

  def setup(challenge_case)
    eval challenge_case.setup
  end

  def run_solution
    status = Timeout::timeout(challenge.maximum_execution_time) do
      thread = Thread.new { eval solution.code }
    end
  end

  def run
    output = {}

    @challenge_cases.each do |cc|
      begin
        setup(cc)
        output[cc] = run_solution
      catch Exception => e
        output[cc] = e.message
      end
    end
    return output
  end
end
