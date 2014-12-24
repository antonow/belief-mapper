Rails.application.routes.draw do
  # post '/users' => 'users/registrations#create'
  resources :user_beliefs

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'users/activate' => 'users/registrations#activate'
    put 'users/edit' => 'users/registrations#update'
  end
  # devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # devise_for :users, controllers: { registrations: "users/registrations" }

  # devise_for :users, :controllers => {:registrations => "registrations"}


  # user_session POST   /users/sign_in(.:format)         users/sessions#create

  # post 'login' => 'my_sessions#create'




  resources :beliefs, only: [:index, :filter, :results, :search, :user, :show]
  get 'beliefs' => 'beliefs#index'
  get 'beliefs/user' => 'beliefs#user'
  get 'beliefs/filter' => 'beliefs#filter'
  get 'beliefs/results' => 'beliefs#results'
  post 'beliefs/search' => 'beliefs#search'

  # get 'beliefs/list', to: 'beliefs#list', as: :beliefs_list

  # resources :beliefs do
  #   collection do
  #     get 'list'
  #   end
  # end

  # resources :beliefs do
  #   get 'list', on: :collection
  # end

  get 'list', to: 'beliefs#list', as: :list_beliefs
  get 'users/refresh_question' => 'users#refresh_question'
  post 'users/skip' => 'users#skip'
  get 'users/your_beliefs' => 'users#your_beliefs'

  resources :users, only: [:index, :skip, :show, :your_beliefs]

  resources :demographics, only: [:new, :create, :update, :edit]

  resources :categories, only: [:index, :show]

  resources :comments, only: [:index, :create]

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
