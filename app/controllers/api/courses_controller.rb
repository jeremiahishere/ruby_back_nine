class API::CoursesController < ApplicationController

  load_and_authorize_resource
  respond_to :json
  
  def index
    respond_with @courses = Course.page(params[:page])
  end

  def show
    respond_with @course = Course.find(params[:id])
  end
end