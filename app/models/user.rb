class User < ActiveRecord::Base
  attr_accessible :name, :email, :login_name, :password, :password_confirmation
  
  has_secure_password
  has_many :projects, :dependent => :destroy  

  has_one :github_account, :dependent => :destroy

  has_many :project_rights, :through => :project_permissions, :source => :project, dependent: :destroy 
  has_many :project_permissions

  has_many :friendships
  has_many :friends, through: :friendships, conditions: "status = 'accepted'"
  has_many :requested_friends, through: :friendships, source: :friend,conditions: "status = 'requested'"
  has_many :pending_friends, through: :friendships, source: :friend, conditions: "status = 'pending'"

    
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
    
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
    
    
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
