Rails.application.routes.draw do

  root 'static_pages#home'
  
  get 'companies/show'
  get 'companies/search'
  get '/search', to: 'companies#search'
  get '/sectors/:id', to: 'companies#sectors', as: 'sectors'
  
  resources :users
  resources :companies do
    # Companyテーブルのインポート機能のため
    collection { post :import_from }
  end

end
