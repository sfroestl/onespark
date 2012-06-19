class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :forename, :surname, :city, :about, :avatar_url

  validates :user_id, presence: true
  
  def to_param 
    self.user.username
  end

end
