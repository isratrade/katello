Rails.application.routes.draw do

  mount Katello::Engine => "/katello"
end
