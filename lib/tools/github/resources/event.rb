# See GitHubAPI documentation in lib/github_api.rb
class GitHubApi
  # Represents a single GitHub Event and provides access to its data attributes.
  class Event < Entity
    attr_reader :type, :public, :payload, :repo, :actor, :org, :created_at, :id
  end  
end