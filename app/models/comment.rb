class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { minimum: 2 }
end
