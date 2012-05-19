class TicketsController < ApplicationController
  before_filter :signed_in_user
  before_filter :get_all_projects
  before_filter :find_project
  
  # GET /projects/1/tickets/1
  # GET /projects/1/tickets/1.json
  def show
    @ticket = Ticket.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket }
    end
  end
  
  # GET /projects/1/tickets/new
  # GET /projects/1/tickets/new.json
  def new
    @ticket = @project.tickets.build(params[:ticket])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ticket }
    end
  end
  
  # POST /projects/1/tickets
  # POST /projects/1/tickets.json
  def create
    @ticket = @project.tickets.build(params[:ticket])
    
    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @project, :flash => { :success => 'Ticket was successfully created.' }}
        format.json { render json: @ticket, status: :created, location: @ticket }
      else
        format.html { render action: "new" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /projects/1/tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
  end
  
  # PUT /projects/1/tickets/1
  # PUT /projects/1/tickets/1.json
  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to @project, :flash => { :success => 'Ticket was successfully updated.' }}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /projects/1/tickets/1
  # DELETE /projects/1/tickets/1.json
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
      respond_to do |format|
        format.html { redirect_to @project }
        format.json { head :no_content }
      end
   end
   
  
  private
    def find_project
      @project = Project.find(params[:project_id])
    end
    
    def get_all_projects
      @projects = Project.all
    end

    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Ups, please sign in!"
      end
    end

end
