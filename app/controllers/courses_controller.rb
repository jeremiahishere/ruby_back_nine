class CoursesController < ApplicationController
  
  load_and_authorize_resource
  def index
    @courses = Course.page(params[:page])
  end

  def show
    @course = Course.find(params[:id])
  end

end