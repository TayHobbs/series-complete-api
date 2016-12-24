Rails.application.routes.draw do
  devise_for :users
  post 'login' => 'authentication#login'
  resources :series
  resources :installments, only: [:update, :destroy, :create]
end
