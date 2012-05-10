class TicketsController < ApplicationController
  before_filter :signed_in_user
  before_filter :get_all_projects
  before_filter :find_project
  before_filter :find_ticket, :only => [:show, :edit, :update, :destroy]
  
  def new
    @ticket = @project.tickets.build(params[:ticket])
  end
  
  def create
      @ticket = @project.tickets.build(params[:ticket])
      if @ticket.save
        flash[:success] = "Ticket created!"
        get_all_projects
        redirect_to @project
      else
        flash.now[:error] = "Ticket not created!"
        render 'new'
      end
  end
  
  def edit   
  end
  
  def update
    if @ticket.update_attributes(params[:ticket])
      flash[:success] = "Ticket updated."
      redirect_to @project
    else
      flash[:error] = "Ticket not updated."
      render :action => "edit"
    end
  end
  
  
  def destroy
    @ticket.destroy
      flash[:success] = "Ticket has been deleted."
      redirect_to @project
   end
   
  
  private
    def find_project
      @project = Project.find(params[:project_id])
    end
    
    def get_all_projects
      @projects = Project.all
    end
    
    def find_ticket
        @ticket = @project.tickets.find(params[:id])
    end
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Ups, please sign in!"
      end
    end

end
