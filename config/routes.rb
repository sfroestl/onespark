Onespark::Application.routes.draw do
  # match '/users/:username', :to => 'users#show'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  
  resources :projects do
   resources :tickets
  end
  resources :tickets, :only => [:index, :show]
  
  match '/git/oauth2/auth', :controller => 'rest_github', :action => 'link_oauth2'
  match '/git/oauth2/return_oauth2', :controller => 'rest_github', :action => 'return_oauth2'
  match '/git/oauth2/unlink', :controller => 'rest_github', :action => 'unlink_oauth2'
  match '/git/oauth2/return_oauth2/:id' => "rest_github#return_oauth2", as: :github_callback
  
  match 'users/:id/git/repos', :controller => 'rest_github', :action => 'index'

  match 'users/:id/git/repos/new', :controller => 'rest_github', :action => 'new'
  match 'users/:id/git/repos/create', :controller => 'rest_github', :action => 'create'
  match 'users/:id/git/repos/:repo_name', :controller => 'rest_github', :action => 'show'
  
  root to: 'static_pages#home'
  
  match '/imprint',    to: 'static_pages#imprint'
  match '/more',    to: 'static_pages#more'
  match '/contact',    to: 'static_pages#contact'
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/goodbye', to: 'static_pages#goodbye'
  
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
