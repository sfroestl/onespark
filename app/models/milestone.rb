class Milestone < ActiveRecord::Base
  has_many :tasks
  has_many :comments, :as => :commentable
  
  belongs_to :project
  belongs_to :user

  attr_accessible :desc, :due_date, :goal, :title
  
  validates :title, presence: true, length: { minimum: 4 }
  validates :user_id, presence: true
  validates :project_id, presence:true

  validate :due_date_not_in_past_but_can_be_empty
  
  default_scope :order => 'due_date ASC'
  
  def to_param
    normalized_name = title.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-\.]/, '')
    "#{self.id}-#{normalized_name}"
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

