require Rails.root.to_s + "/lib/solution_runner"

class RunSolution < TrackableTasks::Base
  def run
    # no idea how to make this part work
    # I think we may need to move it to the solution model
    challenge = Challenge.first
    solution = Solution.first
    runner = SolutionRunner.new()
    # this is not entirely correct
    # need to do some validation stuff here as well
    solution.code_output = runner.run
    solution.ran_at = Time.now
    solution.save
  end
end
