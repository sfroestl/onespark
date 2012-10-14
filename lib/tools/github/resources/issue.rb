##
# The Issue Model class
#
# this sub class represents a GitHubApi Issue resource
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class GitHubApi
  # Represents a single GitHub Issue and provides access to its data attributes.
  class Issue < Entity
    attr_reader :url, :html_url, :number, :state, :title, :body, :user,
                :labels, :assignee, :milestone, :comments, :pull_request,
                :closed_at, :created_at, :updated_at


  end
end