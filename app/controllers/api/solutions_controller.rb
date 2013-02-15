class API::SolutionsController < ApplicationController

  load_and_authorize_resource
  respond_to :json
  
  def index
    if user_signed_in?
      if params[:hole_id]
        #The user's top successful solution -- to list on the Hole Detail view
        @solutions =  Solution.where(
          :user_id=>current_user.id,
          :hole_id=>params[:hole_id],
          :sample=>false,
          :success=>true
        ).order(:score).limit(1)
        
        respond_with @solutions
      else
        respond_with @solutions = Solution.where(:user_id=>current_user.id, :sample=>false)
      end
    else
      respond_with nil
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