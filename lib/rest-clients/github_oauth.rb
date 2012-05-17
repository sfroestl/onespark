class GithubOauth
  
  require 'oauth/consumer'
  
  def initialize
    @consumer = OAuth::Consumer.new "02cd371ab6bde5f10077", "d52dca3fd70f1cad8f83420564d4c6644e99dad0", {:site=>"https://github.com"}            
    @request_token=@consumer.get_request_token
    redirect_to @request_token.authorize_url
    
    @access_token=@request_token.get_access_token
    
    # Request all your users agreements
    @response=@access_token.get "/agreements.xml"
  end
end