class API::HolesController < ApplicationController
 
  load_and_authorize_resource
  respond_to :json

  def index
    if params[:course_id]
      @course = Course.find(params[:course_id])
      respond_with @holes = Hole.where(:course_id => params[:course_id]).page(params[:page])
    else
      respond_with @holes = Hole.page(params[:page])
    end
  end

  def show
    @hole = Hole.find(params[:id])
    
    @sample_case = TestCase.where(:hole_id => params[:id], :sample => true)
    @sample_solution = Solution.where(:hole_id => params[:id], :sample => true)
    @creator = User.find(@hole.creator_id)
    @course = Course.find(@hole.course_id)
    
    @top_scores = Solution.select("user_id, MIN(score) as `score`").where(:hole_id=>@hole.id, :success=>true).group(:user_id).order(:score).limit(5)
    @top_scores.each_with_index do |score, index|
      @top_user = User.find(score.user_id)
      @top_scores[index]["user"] = @top_user
    end
    
    @hole["sample_test_case_setup"] = @sample_case[0].setup
    @hole["sample_test_case_output"] = @sample_case[0].expected_output
    @hole["sample_solution_code"] = @sample_solution[0].code
    @hole["creator"] = @creator
    @hole["course"] = @course
    @hole["top_scores"] = @top_scores
    respond_with @hole
  end
end