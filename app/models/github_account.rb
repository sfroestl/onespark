class GithubAccount < ActiveRecord::Base	
  belongs_to :user
  has_one :project
  
  attr_accessible :access_token, :project_id
  
  validates :user_id, presence: true

end
