class Project < ActiveRecord::Base
  attr_accessible :desc, :due_date, :title

  has_many :milestones, :dependent => :destroy # ensures to destroy all milestones related to project
  has_many :user_rights, :through => :project_permissions, :source => :user, dependent: :destroy
  has_many :project_permissions

  belongs_to :user

  validates :title, presence: true
  validates :user_id, presence: true
  
  validate :due_date_not_in_past_but_can_be_empty

  def to_param
    normalized_name = title.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-\.]/, '')
    "#{self.id}-#{normalized_name}"
  end

  def admin?(user)
    user_right = project_permissions.find_by_user_id(user.id)
    user_right.permission == 3
  end

  def admin!(user)
    project_permissions.create!(user_id: user.id, permission: 3 )
  end

  def writer?(user)
    user_right = project_permissions.find_by_user_id(user.id)
    user_right.permission == 2
  end

  def writer!(user)
    project_permissions.create!(user_id: user.id, permission: 2 ) 
  end

  def reader?(user)
    user_right = project_permissions.find_by_user_id(user.id)
    user_right.permission == 1
  end

  def reader!(user)
    project_permissions.create!(user_id: user.id, permission: 1 ) 
  end

  def owner?(user)
    user.id == user_id
  end

  def owner_id
    user_id
  end

  def due_date_not_in_past_but_can_be_empty
    if self.due_date.nil?
      true
    elsif  self.due_date < DateTime.current
      errors.add(:due_date, 'You can\'t complete tasks in the past!')
    end
  end
  
end

