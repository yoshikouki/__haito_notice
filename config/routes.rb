Rails.application.routes.draw do
  root 'static_pages#home'
  resources :companys
  #get 'companys/show'
  


end
