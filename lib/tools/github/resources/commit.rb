##
# The Commit Model class
#
# this sub class represents a GitHubApi Commit resource
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012


class GitHubApi
  # Represents a single GitHub Issue and provides access to its data attributes.
  class Commit < Entity
    attr_reader :url, :sha, :commit, :author, :message, :parents
  end
end