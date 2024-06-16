Rails.application.routes.draw do
  root "static_pages#top"
  resources :users
  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
    collection do
      get :bookmarks
    end
  end
  resources :bookmarks, only: %i[create destroy]
  resources :password_resets, only: %i[new create edit update]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
