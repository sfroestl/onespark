class GithubOauth
  
  require 'rest_client'
  
  def validate_oauth_token(oauth_verifier, callback_url)
    puts "GithubOauth: Starting validation..."
    response = RestClient.get('https://github.com/login/oauth/access_token', :params => { client_id: OAUTH2_CONFIG['github_client_id'], code: oauth_verifier, client_secret:OAUTH2_CONFIG['github_client_secret']})
    puts "GithubOauth: response: \n #{response}" 
    resp_hash = Hash.from_xml(response)
    puts resp_hash
    token = resp_hash['OAuth']['access_token']
    puts "Access Token: " + token
    return token
  end  
end