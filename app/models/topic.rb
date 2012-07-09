class Topic < ActiveRecord::Base
  attr_accessible :creator_id, :desc, :title

  belongs_to :project
  belongs_to :creator, class_name: 'User', primary_key: 'id', foreign_key: 'creator_id'
 
  has_many :comments, as: :commentable
  validates :title, presence:true, length: { minimum: 4 }
  validates :project_id, presence:true
  validates :creator_id, presence:true

  def to_param
    normalized_name = title.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-]/, '')
    "#{self.id}-#{normalized_name}"
  end
end
