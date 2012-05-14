class Github

  
  # the URL for the Github endpoint
  @@base_url
  @@username
  @@password

  def initialize(username, password)
    Rails.logger.info ">> Class Github loaded"
    @@username = username
    @@password = password
    @@base_url = 'https://api.github.com/'
  end

  
  def getReposArray
    Rails.logger.info ">> Class Github: getRepos "
    #debugger
    add_url = "users/#{@@username}/repos"
    Rails.logger.info ">> class Github: getReposArray, URL: " + @@base_url + add_url
    json_response = RestClient.get(@@base_url + add_url)
    objArray = JSON.parse(json_response)
  end
  
  def getRepoDetailsHash(repo_name)
    add_url = "repos/#{@@username}/#{repo_name}"
    json_response = RestClient.get(@@base_url + add_url)
    Rails.logger.info ">> class Github: getRepoDetailsHash, URL: " + @@base_url + add_url
    puts repoHash = JSON.parse(json_response)
    repoHash = JSON.parse(json_response)
  end

end