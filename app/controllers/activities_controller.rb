class ActivitiesController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
    
  def index
    #@activities = @user.activities.find(params[:id])
  end
  
  def create
    @activity = current_user.activities.build(params[:activity])
      if @activity.save
        flash[:success] = "Activity created!"
        redirect_to @current_user
      else
        flash[:error] = "Activity not created!"
        redirect_to @current_user
      end
  end
  
  def destroy
    
  end
end
