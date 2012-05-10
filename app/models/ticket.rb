class Ticket < ActiveRecord::Base
  belongs_to :project
  attr_accessible :desc, :due_date, :title
  
  validates :title, presence:true, length: { minimum: 4 }
  validates :project_id, presence:true

  validate :due_date_not_in_past
  
  # Default order descending depening on due_date  
    default_scope order: 'tickets.due_date ASC'

    def due_date_not_in_past
       if self.due_date.nil?
         true
       elsif  self.due_date < DateTime.current
         errors.add(:due_date, 'You can\'t complete tasks in the past!')
       end
     end

end
