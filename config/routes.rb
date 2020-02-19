Rails.application.routes.draw do
  root 'static_pages#home'
  get '/search', to: 'companys#search'
  resources :companys
  


end
