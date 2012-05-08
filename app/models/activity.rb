class Activity < ActiveRecord::Base
  attr_accessible :description, :title, :due_date
  belongs_to :user
  
  validates :user_id, presence:true
  validates :title , presence:true

  validate :due_date_not_in_past_but_can_be_empty

# Default order descending depening on due_date  
  default_scope order: 'activities.due_date ASC'
  
  def due_date_not_in_past_but_can_be_empty
    if self.due_date.nil?
      true
    elsif  self.due_date < DateTime.current
      errors.add(:due_date, 'You can\'t complete tasks in the past!')
    end
  end
end
