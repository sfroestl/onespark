##
# The OrgsAPI sub-class
#
# only used via GitHubApi
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class GitHubApi
  # Provides access to the GitHub Orgs API (http://developer.github.com/v3/orgs/)
  #
  # example:
  #
  #   api = GitHubApi.new(ACCESS_TOKEN)
  #
  #   # get list of all orgs to which the user belongs
  #   orgs = api.orgs.list
  #   #=> returns an array of GitHubApi::Org instances
  #
  #   an_org = api.orgs.get('github')
  #   #=> returns an instance of GitHubApi::Org
  #
  #   an_org.name
  #   #=> 'GitHub'
  #
  class OrgsAPI
    # Typically not used directly. Use GitHubApi#orgs instead.
    #
    # +connection+:: an instance of GitHubApi
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubApi::Org instances representing the
    # public and private orgs to which the current user belongs.
    def list
      @connection.get('/user/orgs').map do |org_data|
        GitHubApi::Org.new(self, org_data)
      end
    end

    # Returns a GitHubApi::Org instance for the specified +org_login+.
    #
    # +org_login+:: the string ID of the organization, e.g. "github"
    def get(org_login)
      org_data = @connection.get("/orgs/#{org_login}")
      GitHubApi::Org.new_with_all_data(self, org_data)
    end

    # Returns an array of GitHubApi::Repo instances representing the repos
    # that belong to the specified org.
    #
    # +org_login+:: the string ID of the organization, e.g. "github"
    def list_repos(org_login)
      @connection.get("/orgs/#{org_login}/repos").map do |repo_data|
        GitHubApi::Repo.new(@connection.repos, repo_data)
      end
    end

    # Returns an array of GitHubApi::User instances representing the members
    # who belong to the specified organization.
    #
    # +org_login+:: the string ID of the organization, e.g. "github"
    def list_members(org_login)
      @connection.get("/orgs/#{org_login}/members").map do |user_data|
        GitHubApi::User.new(@connection.users, user_data)
      end
    end

    # Returns an array of GitHubApi::User instances representing the members
    # who belong to the specified organization who have publicly identified
    # themselves as members of this organization.
    #
    # +org_login+:: the string ID of the organization, e.g. "github"
    def list_public_members(org_login)
      @connection.get("/orgs/#{org_login}/public_members").map do |user_data|
        GitHubApi::User.new(@connection.users, user_data)
      end
    end
  end
end
