class Project < ActiveRecord::Base
  attr_accessible :desc, :due_date, :title
  has_many :milestones, :dependent => :destroy # ensures to destroy all milestones related to project
  belongs_to :user, :foreign_key => "creator_id"
  
  validates :title, presence:true
  
  validate :due_date_not_in_past_but_can_be_empty
  
  def due_date_not_in_past_but_can_be_empty
    if self.due_date.nil?
      true
    elsif  self.due_date < DateTime.current
      errors.add(:due_date, 'You can\'t complete tasks in the past!')
    end
  end
  
end

