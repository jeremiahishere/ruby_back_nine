class Admin::CoursesController < ApplicationController

  def index
    @courses = Course.all.page(params[:page])
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to(admin_course_path(@course), :notice => 'Successfully created a new course') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(admin_course_path(@course), :notice => 'Successfully updated a course') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(admin_courses_path, :notice => "Succesfully deleted a course") }
    end
  end
end
