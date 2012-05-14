# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Onespark::Application.initialize!

#Logger
#Rails.logger = Log4r::Logger.new("Application Log")