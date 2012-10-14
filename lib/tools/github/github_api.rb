##
# The GitHubApi class
#
# this class manages all connections to GitHub API
# Its an extension of the provided GitHub API gem
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012



class GitHubApi

# the required sub classes
require 'rest-client'
require 'json'
require 'tools/github/resources/entity'
require 'tools/github/resources/issues_api'
require 'tools/github/resources/issue'
require 'tools/github/resources/issue_comment'
require 'tools/github/resources/users_api'
require 'tools/github/resources/user'
require 'tools/github/resources/orgs_api'
require 'tools/github/resources/org'
require 'tools/github/resources/repos_api'
require 'tools/github/resources/repo'
require 'tools/github/resources/commits_api'
require 'tools/github/resources/commit'
require 'tools/github/resources/events_api'
require 'tools/github/resources/event'

  # Raised when an API request returns a 404 error
  NotFound = Class.new(RuntimeError)

  # Raised when an API request uses an invalid access token
  Unauthorized = Class.new(RuntimeError)

  # Raised when an API request is missing required data
  MissingRequiredData = Class.new(RuntimeError)

  # fetches the api token with received verifier code
  def self.get_token(oauth_verifier_code)

  	Rails.logger.info "> GitHubApi: Fetching Token"

  	response = RestClient.get(GITHUB_CONFIG['token_url'],
  														:params => {
  															client_id: GITHUB_CONFIG['id'],
  															code: oauth_verifier_code,
  															client_secret: GITHUB_CONFIG['secret']
  															})

  	Rails.logger.info "> GitHubApi: response: \n #{response}"

  	resp_hash = Hash.from_xml(response)
    token = resp_hash['OAuth']['access_token']
  end

  # initializes the api with access token
	def init_with_token(access_token)
		Rails.logger.info "> GitHubApi: init_with_token"

    if access_token
      Rails.logger.info "> GitHubApi: token: #{access_token}"
      @access_token = access_token
    end
  end


  # Entry-point for access to the GitHub Users API
  #
  # Returns an instance of GitHubApi::UserAPI that will use the access_token
  # associated with this instance.
  def users
    UsersAPI.new(self)
  end

  # Entry-point for access to the GitHub Orgs API
  #
  # Returns an instance of GitHubApi::OrgsAPI that will use the access_token
  # associated with this instance.
  def orgs
    OrgsAPI.new(self)
  end

  # Entry-point for access to the GitHub Repos API
  #
  # Returns an instance of GitHubApi::ReposAPI that will use the access_token
  # associated with this instance.
  def repos
    Rails.logger.info "> GitHubApi: repos"
    return ReposAPI.new(self)
  end

  # Entry-point for access to the GitHub Issues API
  #
  # Returns an instance of GitHubApi::IssuesAPI that will use the access_token
  # associated with this instance
  def issues
    return IssuesAPI.new(self)
  end

  # Entry-point for access to the GitHub Commits API
  #
  # Returns an instance of GitHubApi::CommitsAPI that will use the access_token
  # associated with this instance
  def commits
    CommitsAPI.new(self)
  end

  # Entry-point for access to the GitHub Events API
  #
  # Returns an instance of GitHubApi::EventsAPI that will use the access_token
  # associated with this instance
  def events
    EventsAPI.new(self)
  end

  def get(path, params={}) #:nodoc:
    result = RestClient.get("https://api.github.com" + path,
                            {:accept => :json,
                             :authorization => "token #{@access_token}"}.merge({:params => params}))
    JSON.parse(result)
  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end

  def post(path, params={}) #:nodoc:
    result = RestClient.post("https://api.github.com" + path, JSON.generate(params),
                            {:accept => :json,
                             :authorization => "token #{@access_token}"})
    JSON.parse(result)
  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end

  def patch(path, params={}) #:nodoc:
    result = RestClient.post("https://api.github.com" + path, JSON.generate(params),
                            {:accept => :json,
                             :authorization => "token #{@access_token}"})
    JSON.parse(result)
  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end

  def delete(path) #:nodoc:
    result = RestClient.delete("https://api.github.com" + path,
                            {:accept => :json,
                             :authorization => "token #{@access_token}"})
    JSON.parse(result)
  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end



  private

		def get_client
			client = OAuth2::Client.new(get_client_id, get_client_secret, site: get_basic_url)
		end
end






