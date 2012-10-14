##
# The Comment Model class
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012



class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { minimum: 2 }

  default_scope :order => 'created_at DESC'
end
