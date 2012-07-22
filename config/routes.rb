Onespark::Application.routes.draw do



  # resources :tasks, controller: 'milestones', action: 'show' do
  #   resources :comments
  # end
  resources :comments, only: [:edit, :update]

  # match '/users/:username', :to => 'users#show'
  resources :users

  resources :sessions, only: [:new, :create, :destroy]
  namespace :tools do 
    resources :github_accounts     
  end

  resources :tasks do
    resources :comments
  end
  resources :posting do
    resources :comments
  end

  resources :projects do
    resources :postings, except: [:show, :index]
    resources :postings, only: [:show, :index], to: 'topics#index'
    resources :tasklists do
      resources :tasks, except: [:show, :index] do
        resources :comments
      end
    end
    resources :tasks
    resources :topics
    resources :coworkers, :controller => 'project_coworkers'
    resources :tasks, only: [:show, :index], to: 'tasklists#index'
  end
  # resources :milestones, except: [:index]
  # resources :profiles , only: [:show, :index]

  resources :friendships, only: [:create, :destroy, :update]

  # Friendship
  post 'friendship/accept/:friend_id', :to => 'friendships#accept'
  post 'friendship/remove/:friend_id', :to => 'friendships#remove'

  # Profile
  get '/profiles/:username', :to => 'profiles#show', as: 'profile'
  put '/profiles/:username', :to => 'profiles#update'
  get '/profiles/:username/edit', :to => 'profiles#edit', as: 'edit_profile'
  get '/profiles', :to => 'profiles#index', as: 'profiles'
  

  # Dropbox Oauth
  match '/projects/:project_id/dropbox/auth', to: 'tools/dropbox#authorize', as: :project_dropbox_auth
  match '/dropbox/unlink', to: 'tools/dropbox#unlink', as: :user_dropbox_unlink
  match '/dropbox/auth', to: 'tools/dropbox#authorize', as: :user_dropbox_auth
  match '/users/:username/dropbox', to: 'tools/dropbox#index', as: :user_dropbox_account
  match '/projects/:project_id/dropbox', to: 'tools/dropbox#show', as: :project_dropbox
  match '/projects/:project_id/dropbox/new', to: 'tools/dropbox#new', as: :new_project_dropbox
  match '/projects/:project_id/dropbox/upload_file', to: 'tools/dropbox#upload', as: :dropbox_upload_file
  match '/projects/:project_id/dropbox/delete_file', to: 'tools/dropbox#delete_file', as: :dropbox_delete_file
  match '/projects/:project_id/dropbox/add_folder', to: 'tools/dropbox#add_folder', as: :dropbox_add_folder
  match '/projects/:project_id/dropbox/folder', to: 'tools/dropbox#show'
  match '/projects/:project_id/dropbox/download', to: 'tools/dropbox#download', as: :dropbox_download
  match 'dropbox/unlink'


  # Github Oauth procedure
  match '/git/auth', to: 'tools/github_accounts#auth', as: :github_auth
  match '/git/callback',  to: 'tools/github_accounts#callback'
  match '/git/unlink', to: 'tools/github_accounts#unlink', as: :github_unlink
  match '/git/oauth2/callback/:id' => "tools/github_accounts#callback", as: :github_callback

  # Github repositories
  # match '/projects/:id/repositories/github/new', :to => 'tools/github#new'
  match '/users/:username/github', to: 'tools/github_repositories#index', as: :user_github_repos
  post '/users/:username/github/create_repo', to: 'tools/github_repositories#create_repo', as: :project_github_repo
  post '/projects/:project_id/github/link_repo', to: 'tools/github_repositories#create', as: :project_github_link_repo
  match '/projects/:project_id/github', to: 'tools/github_repositories#show', as: :project_github
  get '/projects/:project_id/github/new', to: 'tools/github_repositories#new', as: :new_project_github
  get '/projects/:project_id/github/issues', to: 'tools/github_repositories#issues', as: :project_github_issues
  get '/projects/:project_id/github/commits', to: 'tools/github_repositories#commits', as: :project_github_commits
  # Github issues
  post '/projects/:project_id/github/close_issue/:issue_id', to: 'tools/github_repositories#close_issue', as: :project_github_close_issue
  post '/projects/:project_id/github/create_issue', to: 'tools/github_repositories#create_issue', as: :project_github_issue



  # match '/users/:id/git/repos', :controller => 'rest_github', :action => 'index'
  # match '/users/:id/git/repos/new', :controller => 'rest_github', :action => 'new'
  # match '/users/:id/git/repos/create', :controller => 'rest_github', :action => 'create'
  # match '/users/:id/git/repos/:repo_name', :controller => 'rest_github', :action => 'show'

  root to: 'static_pages#home'
  
  # static pages  
  match '/imprint',    to: 'static_pages#imprint'
  match '/more',    to: 'static_pages#more'
  match '/contact',    to: 'static_pages#contact'
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/goodbye', to: 'static_pages#goodbye'
  match '/design',    to: 'static_pages#newdesign'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
