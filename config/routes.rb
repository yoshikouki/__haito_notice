Rails.application.routes.draw do
  root 'static_pages#home'
  resources :companys
  get '/search', to: 'companys#search'
  


end
