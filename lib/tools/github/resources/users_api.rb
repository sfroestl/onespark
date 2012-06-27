# See GitHubApi documentation in lib/github_v3_api.rb
class GitHubApi
  # Provides access to the GitHub Users API (http://developer.github.com/v3/users/)
  #
  # example:
  #
  #   api = GitHubApi.new(ACCESS_TOKEN)
  #
  #   # get list of logged-in user
  #   a_user = api.current
  #   #=> returns an instance of GitHubApi::User
  #
  #   a_user.login
  #   #=> 'jwilger'
  #
  class UsersAPI
    # Typically not used directly. Use GitHubApi#users instead.
    #
    # +connection+:: an instance of GitHubApi
    def initialize(connection)
      @connection = connection
    end

    # Returns a single GitHubApi::User instance representing the
    # currently logged in user
    def current
      user_data = @connection.get("/user")
      GitHubApi::User.new(self, user_data)
    end
    
    # Returns a GitHubApi::User instance for the specified +username+.
    #
    # +username+:: the string login of the user, e.g. "octocat"
    def get(username)
      user_data = @connection.get("/users/#{username}")
      GitHubApi::User.new_with_all_data(self, user_data)
    end
    
  end
end
