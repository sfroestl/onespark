class Ticket < ActiveRecord::Base
  belongs_to :project
  attr_accessible :desc, :due_date, :title
end
