class API::SolutionsController < ApplicationController

  load_and_authorize_resource
  respond_to :json
  
  def index
    respond_with @courses = Course.page(params[:page])
  end

  def show
    respond_with @course = Course.find(params[:id])
  end
  
  def create
    @solution = Solution.new(params[:solution]);
    @solution["user_id"] = current_user.id
    @solution.save
    @solution.check_solution
    respond_with(@solution, :location => nil)
  end
end