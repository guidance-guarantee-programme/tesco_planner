Rails.application.routes.draw do
  root 'bookings#index'

  resources :locations, only: :index do
    resources :rooms, only: :index
  end
end
