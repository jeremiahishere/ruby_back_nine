class HolesController < ApplicationController
  
  load_and_authorize_resource
  
  def index
    if params[:course_id]
      @course = Course.find(params[:course_id])
      @holes = Hole.where(:course_id => params[:course_id]).page(params[:page])
    else
      @holes = Hole.page(params[:page])
    end
  end

  def show
    @hole = Hole.find(params[:id])
  end
  
end