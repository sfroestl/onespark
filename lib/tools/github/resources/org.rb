##
# The Org Model class
#
# this sub class represents a GitHubApi Org resource
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class GitHubApi
  # Represents a single GitHub Org and provides access to its data attributes.
  class Org < Entity
    attr_reader :avatar_url, :billing_email, :blog, :collaborators,
      :company, :created_at, :disk_usage, :email, :followers, :following,
      :html_url, :id, :location, :login, :name, :owned_private_repos, :plan,
      :private_gists, :private_repos, :public_gists, :public_repos, :space,
      :total_private_repos, :type, :url

    # Returns an array of GitHubApi::Repo instances representing the repos
    # that belong to this org
    def repos
      api.list_repos(login)
    end

    # Returns an array of GitHubApi::User instances representing the users
    # who are members of the organization
    def members
      api.list_members(login)
    end

    # Returns an array of GitHubApi::User instances representing the users
    # who are public members of the organization
    def public_members
      api.list_public_members(login)
    end

    private

    def natural_key
      [data['login']]
    end
  end
end
