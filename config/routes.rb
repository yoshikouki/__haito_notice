Rails.application.routes.draw do
  root 'static_pages#home'
  get '/search', to: 'companies#search'
  resources :companies
  


end
