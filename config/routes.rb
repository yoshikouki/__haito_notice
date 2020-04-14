Rails.application.routes.draw do

  get 'tds/daily'

  root 'static_pages#home'
  
  # 企業一覧・検索
  get '/search', to: 'companies#search'
  get '/sectors/:id', to: 'companies#sectors', as: 'sectors'

  # ユーザー機能
  get '/signup', to: 'users#new'
  get '/mypage', to: 'users#mypage'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # ウォッチリスト
  get '/feed', to: 'users#feed', as: 'feed'
  get '/feed/watchlist', to: 'users#watchlist', as: 'watchlist'

  # TDコントローラー
  get '/daily', to: 'tds#daily'

  
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:edit, :update]

  post 'watchlists/:id', to: 'watchlists#create', as: 'watch'
  delete 'watchlists/:id', to: 'watchlists#destroy', as: 'unwatch'

  resources :companies, only: [:index, :show] do
    # Companyテーブルのインポート機能のため
    collection { post :import_from }
  end

end
