class API::SolutionsController < ApplicationController

  load_and_authorize_resource
  respond_to :json
  
  def index
    if params[:hole_id]
      respond_with @solutions = Solution.where(:user_id=>current_user.id, :hole_id=>params[:hole_id])
    else
      respond_with @solutions = Solution.where(:user_id=>current_user.id)
    end
  end

  def show
    respond_with @solution = Solution.find(params[:id])
  end
  
  def create
    @solution = Solution.new(params[:solution]);
    @solution["user_id"] = current_user.id
    @solution.save
    @solution.check_solution
    respond_with(@solution, :location => nil)
  end
end