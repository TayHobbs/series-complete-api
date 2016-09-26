Rails.application.routes.draw do
  devise_for :users
  resources :series
  resources :installments, only: [:update, :destroy, :create]
end
