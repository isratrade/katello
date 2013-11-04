Rails.application.routes.draw do

  mount Katello::Engine => "/katello"

  resources :users

  root :to => 'application#home'

end
