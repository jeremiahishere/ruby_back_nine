class Admin::HolesController < ApplicationController

  def index
    @holes = Hole.all.page(params[:page])
  end

  def show
    @hole = Hole.find(params[:id])
  end

  def new
    @hole = Hole.new
  end

  def create
    @hole = Hole.new(params[:hole])

    respond_to do |format|
      if @hole.save
        format.html { redirect_to(admin_hole_path(@hole), :notice => 'Successfully created a new hole') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @hole = Hole.find(params[:id])
  end

  def update
    @hole = Hole.find(params[:id])

    respond_to do |format|
      if @hole.update_attributes(params[:hole])
        format.html { redirect_to(admin_hole_path(@hole), :notice => 'Successfully updated a hole') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @hole = Hole.find(params[:id])
    @hole.destroy

    respond_to do |format|
      format.html { redirect_to(admin_holes_path, :notice => "Succesfully deleted a hole") }
    end
  end
end
