class GithubOauth
  
  attr_accessor :access_token
  
  require 'rest_client'
  
  def initialize_token(access_token)
    Rails.logger.info "init GithubOauth access token"
    @@access_token = access_token
  end
  
  def validate_oauth_token(oauth_verifier, callback_url)
    
    Rails.logger.info "GithubOauth: Starting validation..."
    response = RestClient.get(token_url, :params => { client_id: client_id, code: oauth_verifier, client_secret: client_secret })
    
    Rails.logger.info "GithubOauth: response: \n #{response}" 
    resp_hash = Hash.from_xml(response)
    token = resp_hash['OAuth']['access_token']
  end
  
  def getReposList
    url = "#{basic_url}/user/repos?access_token=#{@@access_token}"
    Rails.logger.info "GithubOauth - getRepos call url #{url}"
    response = getMethodReturnJson(url)
  end
  
  def getRepoDetails(repo_owner, repo_name)
    url = "#{basic_url}/repos/#{repo_owner}/#{repo_name}"
    Rails.logger.info "GithubOauth - getReopDetails call #{url}"
    response = getMethodReturnJson(url)
  end
  
  def getRepoCommitsList(repo_owner, repo_name)
    url = "#{basic_url}/repos/#{repo_owner}/#{repo_name}/commits"
    Rails.logger.info "GithubOauth - getRepoCommitsList call #{url}"
    response = getMethodReturnJson(url)
  end
  
  def getRepoCollaboratorsList(repo_owner, repo_name)
    url = "#{basic_url}/repos/#{repo_owner}/#{repo_name}/collaborators"
    Rails.logger.info "GithubOauth - getRepoCollaboratorsList call #{url}"
    response = getMethodReturnJson(url)    
  end
  
  def getAuthorisations
    url = "#{basic_url}/authorizations"
    Rails.logger.info "GithubOauth - getAuthorisations call #{url}"
    response = getMethodReturnJson(url)
  end

  def deleteAuthorisations(app_id)
    url = "#{basic_url}/authorizations/#{app_id}" 
    Rails.logger.info "GithubOauth - deleteAuthorisations call #{url}"
    response = deleteMethod(url) 
  end
  
  private 
  
  def getMethodReturnJson(url)
    Rails.logger.info ">> GithubOauth: getMethodReturnJson, URL: #{url}" 
    json_response = RestClient.get url
     
    response_hash = JSON.parse(json_response)
    
    Rails.logger.info ">> GithubOauth: json response code: #{json_response.code}" 
    return response_hash
  end
  
  def postMethod(url, params)
    Rails.logger.info ">> GithubOauth: postMethod, URL: #{url}" 
    json_response = RestClient.post url, params: params
    Rails.logger.info ">> GithubOauth: postMethod response code: #{json_response.code}"

  end

  def deleteMethod(url)
    Rails.logger.info ">> GithubOauth: deleteMethod, URL: #{url}" 
    json_response = RestClient.delete url
    Rails.logger.info ">> GithubOauth: deleteMethod response code: #{json_response.code}"
  end

  def basic_url
    OAUTH2_CONFIG['github_client_basic_url']
  end
  
  def client_id
    OAUTH2_CONFIG['github_client_id']
  end
  
  def client_secret
    OAUTH2_CONFIG['github_client_secret']
  end
  
  def token_url
    OAUTH2_CONFIG['github_client_token_url']
  end
end