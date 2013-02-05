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
    respond_with @hole = Hole.find(params[:id])
  end
  
end