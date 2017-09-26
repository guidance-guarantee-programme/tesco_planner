require 'sidekiq/web'

Rails.application.routes.draw do
  root 'slots#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :locations, only: %i[index show] do
        resources :appointments, only: :create
      end
    end
  end

  resources :appointments, only: %i[index show edit update] do
    resource :reschedule, only: %i[edit update]
    resources :activities, only: :create
  end

  resources :rooms, only: :index
  resources :slots, only: %i[index create destroy]

  namespace :admin do
    resources :locations
  end

  mount Sidekiq::Web, at: '/sidekiq', constraints: AuthenticatedUser.new
end
