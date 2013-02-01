module Admin
  class AdminController < ApplicationController
    before_filter :verify_admin
    
    private
    def verify_admin
      redirect_to root_url unless user_signed_in?  and current_user.has_role? :admin
    end
    
  end
end