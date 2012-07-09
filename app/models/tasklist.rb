class Tasklist < ActiveRecord::Base
	attr_accessible :desc, :due_date, :title

	has_many :tasks, dependent: :destroy
  has_many :comments, :as => :commentable
  
  belongs_to :project
  belongs_to :creator, class_name: 'User', primary_key:'id', foreign_key: 'creator_id'

  validates :creator_id, presence: true
  validates :title, presence: true
  validates :project_id, presence:true

  validate :due_date_not_in_past_but_can_be_empty

  def to_param
    normalized_name = title.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-]/, '')
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
