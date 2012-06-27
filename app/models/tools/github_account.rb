class Tools::GithubAccount < ActiveRecord::Base
  attr_accessible :access_token

  belongs_to :user
end
