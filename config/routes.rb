Rails.application.routes.draw do
  locales = I18n.available_locales.map(&:to_s).join('|')
  scope "(:locale)", locale: /#{locales}/ do
    # ユーザー機能
    get '/signup', to: 'users#new'
    get '/mypage', to: 'users#mypage'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    # ウォッチリスト
    get '/feed', to: 'users#feed', as: 'feed'
    get '/feed/watchlist', to: 'users#watchlist', as: 'watchlist'
    post 'watchlists/:id', to: 'watchlists#create', as: 'watch'
    delete 'watchlists/:id', to: 'watchlists#destroy', as: 'unwatch'

    # 企業一覧・検索
    get '/search', to: 'companies#search'
    get '/sectors/:id', to: 'companies#sectors', as: 'sectors'

    # TDコントローラー
    get 'tdis/daily', to: 'tdis#daily', as: 'daily'

    resources :users, except: :index
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :companies, only: [:index, :show] do
      # Companyテーブルのインポート機能のため
      collection { post :import_from }
    end

    get '/:locale', to: 'static_pages#home'
    root 'static_pages#home'
  end
end
