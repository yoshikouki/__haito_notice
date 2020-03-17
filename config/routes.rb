Rails.application.routes.draw do

  get 'sessions/new'
  root 'static_pages#home'
  
  # companiesコントローラー
  get '/search', to: 'companies#search'
  get '/sectors/:id', to: 'companies#sectors', as: 'sectors'

  # usersコントローラー
  get '/signup', to: 'users#new'
  get '/mypage', to: 'users#show'

  # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  resources :account_activations, only: [:edit]

  resources :companies do
    # Companyテーブルのインポート機能のため
    collection { post :import_from }
  end

end
