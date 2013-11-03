Rails.application.routes.draw do

  mount Katello::Engine => "/katello"

  resources :users, :except => [:show] do
    collection do
      get 'login'
      post 'login'
      get 'logout'
      get 'auth_source_selected'
      get 'auto_complete_search'
    end
  end


end
