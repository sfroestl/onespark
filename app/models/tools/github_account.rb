##
# The Tools::GithubAccount Model class
#
# belongs to user and stores his access_token
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012


class Tools::GithubAccount < ActiveRecord::Base
  attr_accessible :access_token

  belongs_to :user
end
