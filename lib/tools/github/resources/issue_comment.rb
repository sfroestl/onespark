# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubApi
  # Represents a single GitHub Issue and provides access to its data attributes.
  class IssueComment < Entity
    attr_reader :id, :url, :body, :user, :created_at, :updated_at
  end
end