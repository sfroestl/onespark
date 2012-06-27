# See GitHubApi documentation in lib/github_v3_api.rb
class GitHubApi
  # Provides access to the GitHub Repos API (http://developer.github.com/v3/repos/)
  #
  # example:
  #
  #   api = GitHubApi.new(ACCESS_TOKEN)
  #
  #   # get list of all of the user's public and private repos
  #   repos = api.repos.list
  #   #=> returns an array of GitHubApi::Repo instances
  #
  #   repo = api.repos.get('octocat', 'hello-world')
  #   #=> returns an instance of GitHubApi::Repo
  #
  #   repo.name
  #   #=> 'hello-world'
  #
  class ReposAPI
    # Typically not used directly. Use GitHubApi#repos instead.
    #
    # +connection+:: an instance of GitHubApi
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubApi::Repo instances representing the
    # user's public and private repos
    def list
      @connection.get('/user/repos').map do |repo_data|
        Rails.logger.info "listing repos"
        GitHubApi::Repo.new(self, repo_data)
      end
    end

    # Returns a GitHubApi::Repo instance for the specified +user+ and
    # +repo_name+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def get(user, repo_name)
      org_data = @connection.get("/repos/#{user}/#{repo_name}")
      GitHubApi::Repo.new_with_all_data(self, org_data)
    rescue RestClient::ResourceNotFound
      raise NotFound, "The repository #{user}/#{repo_name} does not exist or is not visible to the user."
    end

    # Returns a GitHubApi::Repository instance representing the Repository
    # that it creates
    # 
    # +data+:: the hash DATA with attributes for the issue, e.g. {:name => "reponame"}
    def create(data={})
      raise MissingRequiredData, "Name is required to create a new repository" unless data[:name]
      repo_data = @connection.post("/user/repos", data)
      GitHubApi::Repo.new_with_all_data(self, repo_data)
    end


    # Returns an array of GitHubApi::User instances for the collaborators of the
    # specified +user+ and +repo_name+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def list_collaborators(user, repo_name)
      @connection.get("/repos/#{user}/#{repo_name}/collaborators").map do |user_data|
        GitHubApi::User.new(@connection.users, user_data)
      end
    end

    # Returns an array of GitHubApi::User instances containing the users who are
    # watching the repository specified by +user+ and +repo_name+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def list_watchers(user, repo_name)
      @connection.get("/repos/#{user}/#{repo_name}/watchers").map do |user_data|
        GitHubApi::User.new(@connection.users, user_data)
      end
    end

    # Returns an array of GitHubApi::Repo instances containing the repositories
    # which were forked from the repository specified by +user+ and +repo_name+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    def list_forks(user, repo_name)
      @connection.get("/repos/#{user}/#{repo_name}/forks").map do |repo_data|
        GitHubApi::Repo.new(self, repo_data)
      end
    end

  end
end
