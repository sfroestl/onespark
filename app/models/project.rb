class Project < ActiveRecord::Base
  attr_accessible :desc, :due_date, :title
end
