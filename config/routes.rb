Rails.application.routes.draw do
  resources :users
  resources :series
  resources :installments, only: [:update, :destroy]
end
