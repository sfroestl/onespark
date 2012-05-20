class GithubAccount < ActiveRecord::Base	
  belongs_to :user
  
  attr_accessible :access_token, :app_id, :user_id
  
  validates :user_id, presence: true

end
