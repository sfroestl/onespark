##
# The Event Model class
#
# this sub class represents a GitHubApi Event resource
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class GitHubApi
  # Represents a single GitHub Event and provides access to its data attributes.
  class Event < Entity
    attr_reader :type, :public, :payload, :repo, :actor, :org, :created_at, :id, :comment
  end
end