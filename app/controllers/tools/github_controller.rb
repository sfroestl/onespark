require 'tools/github_api_v3/github_api'

class Tools::GithubController < ApplicationController
  def new
    Rails.logger.info ">> Github controller new"
  end

  def auth
  	Rails.logger.info "> GithubTool: authorize App"
  	redirect_to "#{GITHUB_CONFIG['auth_url']}?client_id=#{GITHUB_CONFIG['id']}&scope=user,repo"
  end

  def callback
  	Rails.logger.info "> GithubTool: callback"

  	if params[:code] and not params[:code].empty?
  		Rails.logger.info "> GithubTool: authcode: #{params[:code]}"

  		token = GitHubApi.get_token(params[:code])

  		Rails.logger.info "> GithubTool: token: #{token}"
  	end
  end
end
