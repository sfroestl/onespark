# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubApi
  # Represents a single GitHub Issue and provides access to its data attributes.
  class Commit < Entity
    attr_reader :url, :sha, :commit, :author, :message, :parents
  end  
end