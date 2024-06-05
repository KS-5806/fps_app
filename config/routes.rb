Rails.application.routes.draw do
  root "static_pages#top"
  resources :users, only: %i[new create]
  resources :posts do
    resources :comments, only: %i[create edit destroy], shallow: true
  end

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
