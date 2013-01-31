class SolutionRunner
  def initialize(challenge_cases, solution)
    @challenges_cases = challenge_cases
    @solution = solution
  end

  def setup(challenge_case)
    eval challenge_case.setup
  end

  def run_solution
    eval solution.code
  end

  def run
    output = {}

    @challenge_cases.each do |cc|
      begin
        setup(cc)
        output[cc.id] = run_solution
      catch Exception => e
        output[cc.id] = e.message
      end
    end
    return output
  end
end
