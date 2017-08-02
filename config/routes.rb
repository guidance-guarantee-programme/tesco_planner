Rails.application.routes.draw do
  root 'bookings#index'

  resources :locations, only: :index
end
