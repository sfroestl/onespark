class Project < ActiveRecord::Base
  PERMISSIONS = {"write" => 2,"read" => 1,  "admin" => 3}

  attr_accessible :desc, :due_date, :title

  has_many :milestones, :dependent => :destroy # ensures to destroy all milestones related to project
  has_many :coworkers, :through => :project_coworkers, :source => :user, dependent: :destroy
  has_many :admins, :through => :project_coworkers, :source => :user, conditions: "permission == 3", dependent: :destroy
  has_many :writers, :through => :project_coworkers, :source => :user, conditions: "permission == 2", dependent: :destroy
  has_many :readers, :through => :project_coworkers, :source => :user, conditions: "permission == 1", dependent: :destroy
  has_many :project_coworkers, dependent: :destroy
  belongs_to :user

  has_one :github_repository, class_name: "Tools::GithubRepository", dependent: :destroy 

  validates :title, presence: true
  validates :user_id, presence: true
  
  validate :due_date_not_in_past_but_can_be_empty

  default_scope :order => 'due_date ASC'

  def self.by_user(user)
    where(:user_id => user.id)
  end

  def to_param
    normalized_name = title.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-\.]/, '')
    "#{self.id}-#{normalized_name}"
  end

  def admin?(user)
    admin = project_coworkers.find_by_user_id(user.id)
    admin.permission == 3
  end

  def admin!(user)
    project_coworkers.create!(user_id: user.id, permission: 3 )
  end

  def writer?(user)
    writer = project_coworkers.find_by_user_id(user.id)
    writer.permission == 2
  end

  def writer!(user)
    project_coworkers.create!(user_id: user.id, permission: 2 ) 
  end

  def reader?(user)
    reader = project_coworkers.find_by_user_id(user.id)
    reader.permission == 1
  end

  def reader!(user)
    project_coworkers.create!(user_id: user.id, permission: 1 ) 
  end

  def owner?(user)
    user.id == user_id
  end

  def owner_id
    user_id
  end

  private 

    def due_date_not_in_past_but_can_be_empty
      if self.due_date.nil?
        true
      elsif  self.due_date < DateTime.current
        errors.add(:due_date, 'You can\'t complete tasks in the past!')
      end
    end
  
end

