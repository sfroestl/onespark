class Task < ActiveRecord::Base
  attr_accessible :desc, :due_date, :tasklist_id, :milestone_id, :project_id, :title, :creator, :worker

  belongs_to :project
  belongs_to :milestone
  belongs_to :tasklist
  belongs_to :worker, :class_name => 'User', primary_key: 'id', :foreign_key => 'worker_id'
	belongs_to :creator, :class_name => 'User', primary_key: 'id', :foreign_key => 'creator_id'

	has_many :comments, :as => :commentable
	validates :project_id, presence: true
	validates :creator_id, presence: true
	validates :title, presence: true

	default_scope :order => 'due_date ASC'

  def to_param
    normalized_name = title.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-\.]/, '')
    "#{self.id}-#{normalized_name}"
  end
end
