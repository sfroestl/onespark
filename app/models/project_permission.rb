class ProjectPermission < ActiveRecord::Base
  attr_accessible :user_id, :permission
  
  belongs_to :project
  belongs_to :user

  validates :project_id, presence: true
  validates :user_id, presence: true
  validates :permission, presence: true, :inclusion => { :in => [0, 1, 2, 3] }
end
