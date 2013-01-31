require Rails.root.to_s + "/lib/solution_runner"

class RunSolutions < TrackableTasks::Base
  def run
    Solution.all.each do |s|
      if sl.challenge.active && !s.ran?
        s.check_solution #.delay
      end
    end
  end
end
