Rails.application.routes.draw do
  root 'slots#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :locations, only: :index do
        resources :slots, only: :index
      end
    end
  end

  resources :rooms, only: :index
  resources :slots, only: %i[index create destroy]
end
