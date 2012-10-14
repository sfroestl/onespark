##
# The EventsAPI sub-class
#
# only used via GitHubApi
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class GitHubApi
  # Provides access to the GitHub Issues API (http://developer.github.com/v3/events/)
  #
  #
  class EventsAPI
    # Typically not used directly. Use GitHubApi#events instead.
    #
    # +connection+:: an instance of GitHubApi
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubApi::Event instances representing a
    # user's events or events for a repo
    def list(options, params={})
      Rails.logger.info ">> Gihub events API: #{options[:user]} #{options[:repo]}"
      path =
        # if params[:page]
          "/repos/#{options[:user]}/#{options[:repo]}/events?page='1'"
        # else
          # "/repos/#{options[:user]}/#{options[:repo]}/events"
        # end

      Rails.logger.info ">> Gihub events API: path: #{path}"
      @connection.get(path, params).map do |event_data|
        GitHubApi::Event.new(self, event_data)
      end
    end

    # Returns a GitHubApi::event instance for the specified +user+,
    # +repo_name+, and +sha+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the event, e.g. 42
    def issue_events(user, repo_name)
      event_data = @connection.get("/repos/#{user}/#{repo_name}/issues/events", params)
      GitHubApi::Event.new_with_all_data(self, event_data)
    rescue RestClient::ResourceNotFound
      raise NotFound, "The events #{user}/#{repo_name}/events/#{id} do not exist or are not visible to the user."
    end

     # Returns a GitHubApi::commit instance for the specified +user+,
    # +repo_name+, and +sha+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the event, e.g. 42
    def user_events(user)
      event_data = @connection.get("/repos/#{user}/events", params)
      GitHubApi::Event.new_with_all_data(self, event_data)
    rescue RestClient::ResourceNotFound
      raise NotFound, "The events #{user}/#{repo_name}/events/#{id} do not exist or are not visible to the user."
    end

  end
end