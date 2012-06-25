class GitHubApi

require 'rest-client'

 # # Raised when an API request returns a 404 error
 #  NotFound = Class.new(RuntimeError)

 #  # Raised when an API request uses an invalid access token
 #  Unauthorized = Class.new(RuntimeError)

 #  # Raised when an API request is missing required data
 #  MissingRequiredData = Class.new(RuntimeError)



 #  def self.authorize
 #  	client = get_client
 #  	client.auth_code.authorize_url(:redirect_uri => get_redirect_url)

 #  	get '/git/oauth/github' do
	#   	redirect client.web_server.authorize_url(:redirect_uri => get_redirect_url, :scope => 'user,repo')
	# 	end
	# end

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
	def initialize_with_token(access_token)
		Rails.logger.info "> GitHubApi: init GithubOauth access token"
    @access_token = access_token
  end

  # def get(path, params={}) #:nodoc:
  #   result = RestClient.get("https://api.github.com" + path,
  #                           {:accept => :json,
  #                            :authorization => "token #{@access_token}"}.merge({:params => params}))
  #   JSON.parse(result)
  # rescue RestClient::Unauthorized
  #   raise Unauthorized, "The access token is invalid according to GitHub"
  # end

  # def post(path, params={}) #:nodoc:
  #   result = RestClient.post("https://api.github.com" + path, JSON.generate(params),
  #                           {:accept => :json,
  #                            :authorization => "token #{@access_token}"})
  #   JSON.parse(result)
  # rescue RestClient::Unauthorized
  #   raise Unauthorized, "The access token is invalid according to GitHub"
  # end

  # def patch(path, params={}) #:nodoc:
  #   result = RestClient.post("https://api.github.com" + path, JSON.generate(params),
  #                           {:accept => :json,
  #                            :authorization => "token #{@access_token}"})
  #   JSON.parse(result)
  # rescue RestClient::Unauthorized
  #   raise Unauthorized, "The access token is invalid according to GitHub"
  # end

  # def delete(path) #:nodoc:
  #   result = RestClient.delete("https://api.github.com" + path,
  #                           {:accept => :json,
  #                            :authorization => "token #{@access_token}"})
  #   JSON.parse(result)
  # rescue RestClient::Unauthorized
  #   raise Unauthorized, "The access token is invalid according to GitHub"
  # end


  private 

		def get_client
			client = OAuth2::Client.new(get_client_id, get_client_secret, site: get_basic_url)
		end
  	
  	# helper for token url
	  def get_token_url
	  	GITHUB_CONFIG['token_url']
	  end

 		# helper for client secret
	  def get_client_secret
	  	GITHUB_CONFIG['secret']
	  end

	  # helper for client id
	  def get_client_id
	  	GITHUB_CONFIG['id']
	  end

	  # helper for basic url
	  def get_basic_url
	  	GITHUB_CONFIG['basic_url']
	  end

	  # helper for redirect url
	  def get_redirect_url
	  	GITHUB_CONFIG['redirect_url']
	  end
end






