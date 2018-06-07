require 'sidekiq/web'

Rails.application.routes.draw do # rubocop:disable BlockLength
  root 'home#index'

  namespace :mailgun do
    resources :drops, only: :create
  end

  resource :user, only: %i[edit update]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :locations, only: %i[index show] do
        resources :appointments, only: :create
      end
    end
  end

  resources :appointments, only: %i[index edit update] do
    resource :reschedule, only: %i[edit update]
    resource :process, only: :create

    resources :activities, only: :create
  end

  resources :locations, only: :index do
    resources :slots, only: %i[index create destroy]
    resources :rooms, only: :index
    resource :availability, only: :show
  end

  namespace :admin do
    resources :delivery_centres
    resources :locations do
      resources :rooms
    end
    resources :appointments, only: :index
  end

  mount Sidekiq::Web, at: '/sidekiq', constraints: AuthenticatedUser.new
end
