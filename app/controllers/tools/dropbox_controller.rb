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
  layout 'project', except: [:index]

  before_filter :find_project, except: [:authorize, :unlink, :index]

    def authorize
      Rails.logger.info">> Dropbox authorize"
      
        if not params[:oauth_token] then
          # store project id if request from project
          cookies[:oauth_project_id] = params[:project_id]
          Rails.logger.info">> Dropbox AUTH: request: #{request.fullpath} cookie #{cookies[:oauth_project_id]} proj.id #{params[:project_id]}"

          dbsession = DropboxSession.new(APP_KEY, APP_SECRET)

          session[:dropbox_session] = dbsession.serialize #serialize and save this DropboxSession

          # pass to get_authorize_url a callback url that will return the user here
          redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
        else
          # the user has returned from Dropbox
          dbsession = DropboxSession.deserialize(session[:dropbox_session])
          dbsession.get_access_token  #we've been authorized, so now request an access_token
          session[:dropbox_session] = dbsession.serialize
          
          Rails.logger.info ">> DropBox API get_access_token: #{dbsession.access_token}"
          Rails.logger.info ">> DropBox return path #{cookies[:oauth_project_id]}"
          
          # choose redirect url
          unless cookies[:oauth_project_id].eql? ""
            respond_to do |format|
              format.html { redirect_to project_dropbox_path(cookies[:oauth_project_id]), :flash => { :success => 'Successfully linked DropBox account!' } }
            end
          else
            respond_to do |format|
              format.html { redirect_to projects_path, :flash => { :success => 'Successfully linked DropBox account!' } }
              format.js {  }
            end
          end
        end
    end

    def unlink
      respond_to do |format|
        if session[:dropbox_session]
          session[:dropbox_session] = nil
          format.html { redirect_to current_user, :flash => { :success => 'Successfully unliked DropBox account!' } }
          format.js { }
        else
          session[:dropbox_session] = nil
          format.html { redirect_to current_user, :flash => { :success => 'No linked DropBox account!' } }
          format.js { }
        end
      end
    end

    def upload
      # Check if user has no dropbox session...re-direct them to authorize
      client = init_client
      unless client
        flash[:error] = "No DropBox account linked!"
        return redirect_to action: "new"  
      end
        # if request.method != "POST"
        #     # show a file upload page
        #     render :inline =>
        #         "#{info['email']} <br/><%= form_tag({:action => :upload}, :multipart => true) do %><%= file_field_tag 'file' %><%= submit_tag %><% end %>"
        #     return
        # else
            # upload the posted file to dropbox keeping the same name
        begin
          resp = client.put_file("#{params['folder_path']}/#{params[:file].original_filename}", params[:file].read)
        rescue Exception => e
          flash['error'] = "DropBox Error: " + e.message
          return redirect_to :back 
        end
        Rails.logger.info ">> DropBox: upload file: #{params[:file].original_filename} to folder #{params['folder_path']}"
        redirect_to :back, :flash => { :success => "Upload successful! File now at #{resp['path']}" }
        # end
    end

    def delete_file
      
      client = init_client
      unless client
        flash[:error] = "No DropBox account linked!"
        return redirect_to action: "new"  
      end
      
      path = params[:file_path].gsub("%", " ")

      Rails.logger.info ">> DropBox: delete file: #{path}"

      if resp = client.file_delete(path)
        redirect_to :back, :flash => { :success => "Successfully deletet file!" } 
      else
        redirect_to :back, :flash => { :success => "Error deleting file!" } 
      end
    end

    def add_folder
      
      client = init_client
      unless client
        flash[:error] = "No DropBox account linked!"
        return redirect_to action: "new"  
      end

      new_folder_path = "#{params[:folder_path]}/#{params[:folder_name]}"

      Rails.logger.info ">> DropBox: add folder: #{new_folder_path} "
      
      metadata = client.metadata("#{params[:folder_path]}")
      @folders = parse_folders(metadata)

      if request.method == "POST"
        begin
          resp = client.file_create_folder(new_folder_path)
        rescue Exception => e
          return flash['error'] = "DropBox Error: " + e.message
        end
       redirect_to :back, :flash => { :success => "Folder Created!" }        
     end
    end

    def download  

      client = init_client
      unless client
        flash[:error] = "No DropBox account linked!"
        return redirect_to action: "new"  
      end

      path = params[:file_path].gsub("%", " ")
      Rails.logger.info ">> DropBox: download file: #{path}"
      data = client.get_file(path)
      meta = client.metadata(path)
      name = meta['path'].split('/').last
      Rails.logger.info ">> DropBox: download file: #{name}"
      send_data(data, :filename => "#{name}", :disposition => 'attachment')
      # send_file resp
      # redirect_to :back
    end

    def index
      Rails.logger.info ">> DropBox Controller index"

      client = init_client
      unless client
        flash[:error] = "No DropBox account linked!"
        return redirect_to action: "new"  
      end

      info = client.account_info # look up account information
      Rails.logger.info ">> DropBox API index: account_info#{info.inspect}"

      @account_info = info
      metadata = client.metadata('/')
      @folders = parse_folders(metadata)
      @files = parse_files(metadata)

      respond_to do |format|
        format.html { }
        format.js { }
      end
    end

    def show
      Rails.logger.info ">> DropBox Controller show"

      client = init_client
      unless client
        flash[:error] = "No DropBox account linked!"
        return redirect_to action: "new"    
      end

      Rails.logger.info ">> DropBox API show: Path #{params[:folder_path]}"

      metadata = client.metadata("#{params[:folder_path]}")
      Rails.logger.info ">> DropBox API show: DATA #{metadata}"
      @folder = metadata
      @folders = parse_folders(metadata)
      @files = parse_files(metadata)

      respond_to do |format|
        format.html { }
        format.js { }
      end
    end

    def new
    end

    private

    def init_client
      begin
        dbsession = DropboxSession.deserialize(session[:dropbox_session])        
        client = DropboxClient.new(dbsession, ACCESS_TYPE) #raise an exception if session not authorized
      rescue Exception => e
        Rails.logger.error ">> DropBox Controller init_client: " + e.message
        session[:dropbox_session] = nil        
        Rails.logger.error ">> DropBox Controller reset_session!"
        return
      end
      return client
    end

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
