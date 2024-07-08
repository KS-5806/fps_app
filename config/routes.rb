Rails.application.routes.draw do
  root "static_pages#top"
  get 'howto', to: 'static_pages#howto'
  resources :users do
    resource :relationships, only: [:create, :destroy]
    get "followings", to: "relationships#followings", as: "followings"
    get "followers", to: "relationships#followers", as: "followers"
  end
  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
    resource :favorites, only: [:create, :destroy]
    collection do
      get :bookmarks
    end
  end
  get "search_tag", to: "posts#search_tag"

  resources :bookmarks, only: %i[create destroy]
  resources :password_resets, only: %i[new create edit update]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  post '/guest_login', to: 'user_sessions#guest_login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
