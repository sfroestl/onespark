class ApplicationController < ActionController::Base
  protect_from_forgery
  # helper :sessions, :rest_github, :path, :date
  include SessionsHelper, DateHelper, RestGithubHelper
end
