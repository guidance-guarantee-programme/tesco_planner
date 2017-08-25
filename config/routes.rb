Rails.application.routes.draw do
  root 'slots#index'

  resources :rooms, only: :index
  resources :slots, only: %i(index create destroy)
end
