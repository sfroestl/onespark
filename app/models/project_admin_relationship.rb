class ProjectAdminRelationship < ActiveRecord::Base
  attr_accessible :user_id
  belongs_to :project
  belongs_to :user

  validates :project_id, presence: true
  validates :user_id, presence: true
end