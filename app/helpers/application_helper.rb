##
# The ApplicationHelper class
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

module ApplicationHelper

  def full_title(page_title)
    base_title = "One Spark"

    if page_title.empty?
      return base_title
    else
      return "#{base_title} | #{page_title}"
    end
  end


  def find_project
    @project = Project.find(params[:project_id])
  end


end
