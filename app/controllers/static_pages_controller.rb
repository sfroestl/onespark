##
# The StaticPagesController class
#
# It manages all static pages with no variable content
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class StaticPagesController < ApplicationController

  # the one spark landing page
  def home
  	render 'home', layout: nil
  end

end
