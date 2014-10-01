require 'resque/server'

Rails.application.routes.draw do
  resources :user_sessions, only: [ :new, :create, :destroy ]
  get 'login' => 'user_sessions#new', as: :login
  delete 'logout' => 'user_sessions#destroy', as: :logout

  resources :password_resets, only: [ :create, :edit, :update ]

  resources :users do
    member do
      get :activate
      get :edit_password, action: 'edit', edit_password: true
      put :update_password, action: 'update', edit_password: true
    end
  end
  get 'signup' => 'users#new', as: :signup

  # Shorter version of /users/:id/confirm_email?activation_token=:activation_token
  get "confirm_email/:id/:activation_token" => "users#confirm_email", as: :confirm_user_email

  root to: 'home#index'

  #mount Resque::Server.new, :at => "/resque", :constraints => lambda { |request|
  #  current_user.is_admin?
  #}
end
