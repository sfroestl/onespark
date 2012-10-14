##
# The CommitsAPI sub-class
#
# only used via GitHubApi
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class GitHubApi
  # Provides access to the GitHub Issues API (http://developer.github.com/v3/commits/)
  #
  #
  class CommitsAPI
    # Typically not used directly. Use GitHubApi#commits instead.
    #
    # +connection+:: an instance of GitHubApi
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubApi::Commit instances representing a
    # user's commits or commits for a repo
    def list(options, params={})
      Rails.logger.info ">> Gihub commits API: #{options[:user]} #{options[:repo]}"
      path = "/repos/#{options[:user]}/#{options[:repo]}/commits"

      Rails.logger.info ">> Gihub commits API: path: #{path}"
      @connection.get(path, params).map do |commit_data|
        GitHubApi::Commit.new(self, commit_data)
      end
    end

    # Returns a GitHubApi::commit instance for the specified +user+,
    # +repo_name+, and +sha+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the commit, e.g. 42
    def get(user, repo_name, sha)

      commit_data = @connection.get("/repos/#{user}/#{repo_name}/commits/#{sha}", params)
      GitHubApi::Commit.new_with_all_data(self, commit_data)
    rescue RestClient::ResourceNotFound
      raise NotFound, "The commit #{user}/#{repo_name}/commits/#{id} does not exist or is not visible to the user."
    end

  end
end