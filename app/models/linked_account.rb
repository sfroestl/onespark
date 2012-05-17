class LinkedAccount < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :password, :username, :project_id
  

  validates :name, presence: true, 
            uniqueness: { scope: :user_id } 
  validates :password, presence: true
  validates :username, presence: true
  validates :user_id, presence: true
   
  def initialize(name, username, password, user)
    super()
    Rails.logger.info(">> TEST")
      self.name = name
      self.username = username
      self.user_id = user.id
      self.password = password
  end
  
  private
  
  def account_name_must_be_unique_with_same_user_id
    account = LinkedAccount.find_by_user_id(user.id)
  end
end
