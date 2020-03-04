Rails.application.routes.draw do

  root 'static_pages#home'
  
  # companiesコントローラー
  get '/search', to: 'companies#search'
  get '/sectors/:id', to: 'companies#sectors', as: 'sectors'

  # usersコントローラー
  get '/signup', to: 'users#new'
  
  resources :users
  resources :account_activations, only: [:edit]

  resources :companies do
    # Companyテーブルのインポート機能のため
    collection { post :import_from }
  end

end
