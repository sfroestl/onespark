class TicketsController < ApplicationController
  before_filter :find_project
  
  def new
    @ticket = @project.tickets.build
  end
  
  private
    def find_project
      @project = Project.find(params[:project_id])
    end
end
