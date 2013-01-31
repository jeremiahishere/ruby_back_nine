require 'ruby_cop'

class IllegalCodeException < Exception
end

class SolutionRunner
  def initialize(solution)
    @challenge = solution.challenge
    @challenge_cases = solution.challenge.cases.active
    @solution = solution
  end

  def setup(challenge_case)
    eval challenge_case.setup
  end

  def run_solution
    # require 'timeout'
    # status = Timeout::timeout(@challenge.maximum_execution_time + 1) do
    # end

    thread = Thread.new { eval @solution.code }
    thread.join(@challenge.maximum_execution_time)
    return thread.value
  end

  def safe_code?
    policy = RubyCop::Policy.new
    code = RubyCop::NodeBuilder.build(@solution.code)
    code.accept(policy)
  end

  def run
    output = {}
    if @challenge_cases.empty?
      return output
    else
      @challenge_cases.each do |cc|
        begin
          raise "Illegal call found" unless safe_code?
          setup(cc)
          output[cc] = { :value => run_solution }
        rescue Exception => e
          output[cc] = { :error => e.message }
        end
      end
      return output
    end
  end
end
