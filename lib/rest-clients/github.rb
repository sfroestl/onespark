class Github

  
  # the URL for the Github endpoint
  @@base_url
  @@username
  @@password

  def initialize(username, password)
    Rails.logger.info ">> Class Github loaded"
    @@username = username
    @@password = password
    @@base_url = 'https://api.github.com'
  end

  def getUserDetails(username)
    url = @@base_url + "/users/#{username}"
    Rails.logger.info ">> Class Github: getUserDetails, URL" + url
    getMethodReturnJson(url)
  end
  
  def getUserReposArray
    #debugger
    url = @@base_url + "/users/#{@@username}/repos"
    Rails.logger.info ">> Class Github: getRepos, URL" + url
    getMethodReturnJson(url)
  end
  
  def getReposArray
    url = @@base_url + "/user/repos"
    Rails.logger.info ">> Class Github: getRepos, URL" + url
    getMethodReturnJson(url)
  end
  
  def getRepoDetailsHash(repo_name)
    url = @@base_url + "/repos/#{@@username}/#{repo_name}"
    Rails.logger.info ">> class Github: getRepoDetailsHash, URL: " + url
    getMethodReturnJson(url)
  end
  
  def getRepoCommits(repo_name)
    url = @@base_url + "/repos/#{@@username}/#{repo_name}/commits"
    Rails.logger.info ">> class Github: getRepoCommits, URL: " + url
    getMethodReturnJson(url)
  end
  
  def getRepoCommitComments(repo_name)
    url = @@base_url + "/repos/#{@@username}/#{repo_name}/comments"
    Rails.logger.info ">> class Github: getRepoCommitComments, URL: " + url
    getMethodReturnJson(url)
  end

  private 
  
  def getMethodReturnJson(url)
    json_response = RestClient.get(url)
    Rails.logger.info ">> class Github: getMethodReturnJson, URL: " + url
    #puts repoHash = JSON.parse(json_response)
    response_hash = JSON.parse(json_response)
    return response_hash
  end
end