# See GitHubApi documentation in lib/github_v3_api.rb
class GitHubApi
  # Provides access to the GitHub Issues API (http://developer.github.com/v3/issues/)
  #
  # example:
  #
  #   api = GitHubApi.new(ACCESS_TOKEN)
  #
  #   # get list of your issues
  #   my_issues = api.issues.list
  #   #=> returns an array of GitHubApi::Issue instances
  #
  #   # get list of issues for a repo
  #   repo_issues = api.issues.list({:user => 'octocat', :repo => 'hello-world'})
  #   #=> returns an array of GitHubApi::Issue instances
  #
  #   issue = api.issues.get('octocat', 'hello-world', '1234')
  #   #=> returns an instance of GitHubApi::Issue
  #
  #   issue.title
  #   #=> 'omgbbq'
  #
  class IssuesAPI
    # Typically not used directly. Use GitHubApi#issues instead.
    #
    # +connection+:: an instance of GitHubApi
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubApi::Issue instances representing a
    # user's issues or issues for a repo
    def list(options=nil, params={})
      Rails.logger.info ">> Gihub Issues API: #{options[:user]} #{options[:repo]}"
      path = if options && options[:user] && options[:repo]
        "/repos/#{options[:user]}/#{options[:repo]}/issues"
      else
        '/issues'
      end
      Rails.logger.info ">> Gihub Issues API: path: #{path}"
      @connection.get(path, params).map do |issue_data|
        GitHubApi::Issue.new(self, issue_data)
      end
    end

    # Returns a GitHubApi::Issue instance for the specified +user+,
    # +repo_name+, and +id+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the issue, e.g. 42
    def get(user, repo_name, id, params={})
      issue_data = @connection.get("/repos/#{user}/#{repo_name}/issues/#{id.to_s}", params)
      GitHubApi::Issue.new_with_all_data(self, issue_data)
      rescue RestClient::ResourceNotFound
        raise NotFound, "The issue #{user}/#{repo_name}/issues/#{id} does not exist or is not visible to the user."
    end

    # Returns a GitHubApi::Issue instance for the specified +user+,
    # +user+, +repo_name+, +id+ and +params+
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the issue, e.g. 42
    def get_issue_comments(user, repo_name, id, params={})
      @connection.get("/repos/#{user}/#{repo_name}/issues/#{id.to_s}/comments", params).map do |comment_data|
        GitHubApi::IssueComment.new(self, comment_data)
      end          
      rescue RestClient::ResourceNotFound
        raise NotFound, "The issue #{user}/#{repo_name}/issues/#{id} does not exist or is not visible to the user."
    end


    def create_issue_comment(user, repo_name, id, data={})
      raise MissingRequiredData, "Message is required to create a new comment" unless data[:body]
      
      issue_data = @connection.post("/repos/#{user}/#{repo_name}/issues/#{id}/comments", data)
      GitHubApi::Issue.new_with_all_data(self, issue_data)
    end

    # Returns a GitHubApi::Issue instance representing the issue
    # that it creates
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +data+:: the hash DATA with attributes for the issue, e.g. {:title => "omgbbq"}
    def create(user, repo_name, data={})
      raise MissingRequiredData, "Title is required to create a new issue" unless data[:title]
      issue_data = @connection.post("/repos/#{user}/#{repo_name}/issues", data)
      GitHubApi::Issue.new_with_all_data(self, issue_data)
    end

    # Returns a GitHubApi::Issue instance representing the issue
    # that it updated
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the issue, e.g. 42
    # +data+:: the hash with attributes for the issue, e.g. {:body => "lol, wtf"}
    def update(user, repo_name, id, data={})
      issue_data = @connection.patch("/repos/#{user}/#{repo_name}/issues/#{id.to_s}", data)
      GitHubApi::Issue.new_with_all_data(self, issue_data)
    end
  end
end