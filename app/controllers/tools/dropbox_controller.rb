require 'tools/dropbox/dropbox_sdk'


# This is an example of a Rails 3 controller that authorizes an application
# and then uploads a file to the user's Dropbox.

# You must set these
APP_KEY = DBOX_CONFIG['key']
APP_SECRET = DBOX_CONFIG['secret']
ACCESS_TYPE = :dropbox #The two valid values here are :app_folder and :dropbox
                          #The default is :app_folder, but your application might be
                          #set to have full :dropbox access.  Check your app at
                          #https://www.dropbox.com/developers/apps


# Examples routes for config/routes.rb  (Rails 3)
#match 'db/authorize', :controller => 'db', :action => 'authorize'
#match 'db/upload', :controller => 'db', :action => 'upload'

class Tools::DropboxController < ApplicationController
  layout 'project'

  before_filter :find_project

    def authorize
        if not params[:oauth_token] then
            dbsession = DropboxSession.new(APP_KEY, APP_SECRET)

            session[:dropbox_session] = dbsession.serialize #serialize and save this DropboxSession

            #pass to get_authorize_url a callback url that will return the user here
            redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
        else
            # the user has returned from Dropbox
            dbsession = DropboxSession.deserialize(session[:dropbox_session])
            dbsession.get_access_token  #we've been authorized, so now request an access_token
            session[:dropbox_session] = dbsession.serialize

            Rails.logger.info ">> DropBox API get_access_token: #{dbsession}"
            redirect_to :action => 'index', :flash => { :success => 'Successfully linked DropBox account!' }
        end
    end

    def upload
        # Check if user has no dropbox session...re-direct them to authorize
        return redirect_to(:action => 'authorize') unless session[:dropbox_session]

        dbsession = DropboxSession.deserialize(session[:dropbox_session])
        client = DropboxClient.new(dbsession, ACCESS_TYPE) #raise an exception if session not authorized
        info = client.account_info # look up account information

        # if request.method != "POST"
        #     # show a file upload page
        #     render :inline =>
        #         "#{info['email']} <br/><%= form_tag({:action => :upload}, :multipart => true) do %><%= file_field_tag 'file' %><%= submit_tag %><% end %>"
        #     return
        # else
            # upload the posted file to dropbox keeping the same name

            resp = client.put_file("#{params['folder_path']}/#{params[:file].original_filename}", params[:file].read)
            Rails.logger.info ">> DropBox: upload file: #{params[:file].original_filename} to folder #{params['folder_path']}"
            redirect_to :back, :flash => { :success => "Upload successful! File now at #{resp['path']}" }
        # end
    end

    def download      
      # Check if user has no dropbox session...re-direct them to authorize
        return redirect_to(:action => 'authorize') unless session[:dropbox_session]

        dbsession = DropboxSession.deserialize(session[:dropbox_session])
        client = DropboxClient.new(dbsession, ACCESS_TYPE) #raise an exception if session not authorized
        info = client.account_info # look up account information
        path = params[:file_path].gsub("%", " ")
        Rails.logger.info ">> DropBox: download file: #{path}"
        resp = client.get_file_and_metadata(path)
        Rails.logger.info ">> DropBox: download file: #{resp.second}"

        # send_file resp
        # redirect_to :back
    end

    def index
      # Check if user has no dropbox session...re-direct them to authorize
        return redirect_to(:action => 'authorize') unless session[:dropbox_session]

        dbsession = DropboxSession.deserialize(session[:dropbox_session])
        client = DropboxClient.new(dbsession, ACCESS_TYPE) #raise an exception if session not authorized
        info = client.account_info # look up account information
        Rails.logger.info ">> DropBox API index: account_info#{info.inspect}"

        @account_info = client.account_info()
        metadata = client.metadata('/')
        @folders = parse_folders(metadata)
        @files = parse_files(metadata)
    end

    def show
      # Check if user has no dropbox session...re-direct them to authorize
        return redirect_to(:action => 'authorize') unless session[:dropbox_session]

        dbsession = DropboxSession.deserialize(session[:dropbox_session])
        client = DropboxClient.new(dbsession, ACCESS_TYPE) #raise an exception if session not authorized
        info = client.account_info # look up account information
        Rails.logger.info ">> DropBox API show: Path #{params[:folder_path]}"

        metadata = client.metadata("#{params[:folder_path]}")
        Rails.logger.info ">> DropBox API show: DATA #{metadata}"
        @folder = metadata
        @folders = parse_folders(metadata)
        @files = parse_files(metadata)
    end

    private

    def find_project
      @project = Project.find(params[:project_id])
    end

    def parse_folders(metadata)
      Rails.logger.info ">> DropBox: parse_folders"
      toreturn = []
      for data in metadata['contents']
        if data['is_dir'] == true          
          Rails.logger.info ">> #{data['path']} is folder #{data['is_folder']}"
          toreturn.push data
        end
      end
      toreturn
    end

    def parse_files(metadata)
      Rails.logger.info ">> DropBox: parse_files"
      toreturn = []
      for data in metadata['contents']
        if data['is_dir'] == false          
          Rails.logger.info ">> #{data['path']} is file #{data['is_folder']}"
          toreturn.push data
        end
      end
      toreturn
    end
end
