require 'sidekiq/web'

Rails.application.routes.draw do # rubocop:disable BlockLength
  root 'home#index'

  resources :sms_cancellations, only: :create

  namespace :mailgun do
    resources :drops, only: :create
  end

  resource :user, only: %i[edit update]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :employers do
        resources :locations, only: :show, shallow: true do
          resources :appointments, only: :create
        end
      end
    end
  end

  resources :appointments, only: %i[index edit update] do
    resource :reschedule, only: %i[edit update]
    resource :process, only: :create

    resources :activities, only: :create
  end

  resources :locations, only: :index do
    resources :appointments, only: :index
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
