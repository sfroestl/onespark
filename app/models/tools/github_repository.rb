class Tools::GithubRepository < ActiveRecord::Base
  attr_accessible :name, :owner, :url, :user_id

  belongs_to :project

  def self.by_project_id(project)
  	Tools::GithubRepository.find_by_project_id(project.id)
  end
end
