##
# The IssueComment Model class
#
# this sub class represents a GitHubApi IssueComment resource
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class GitHubApi

  # Represents a single GitHub Issue and provides access to its data attributes.
  class IssueComment < Entity
    attr_reader :id, :url, :body, :user, :created_at, :updated_at
  end
end