Rails.application.routes.draw do
  get 'companies/show'

  get 'companies/search'

  root 'static_pages#home'
  get '/search', to: 'companies#search'
  resources :companies do
    collection { post :import_from }
  end
  


end
