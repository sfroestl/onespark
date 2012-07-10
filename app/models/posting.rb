class Posting < ActiveRecord::Base
  attr_accessible :title, :content, :creator_id, :topic_id

  belongs_to :topic
  belongs_to :creator, class_name: 'User', primary_key: 'id', foreign_key: 'creator_id'
 
  has_many :comments, as: :commentable, dependent: :destroy
  
  validates :title, presence:true, length: { minimum: 4 }
  validates :creator_id, presence:true

	default_scope :order => 'created_at DESC'

  def to_param
    normalized_name = title.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-]/, '')
    "#{self.id}-#{normalized_name}"
  end
end
