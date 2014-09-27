require 'resque/server'

Rails.application.routes.draw do
  resources :user_sessions
  resources :password_resets
  resources :users do
    member do
      get :activate
      get :edit_password, action: 'edit', edit_password: true
      put :update_password, action: 'update', edit_password: true
    end
  end
  # Shorter version of /users/:id/confirm_email?activation_token=:activation_token
  get "confirm_email/:id/:activation_token" => "users#confirm_email", as: :confirm_user_email

  get 'user_sessions/new'
  # TODO: change to POST
  get 'user_sessions/create'
  # TODO: change to DELETE
  get 'user_sessions/destroy'
  get 'signup' => 'users#new', as: :signup
  get 'login' => 'user_sessions#new', as: :login
  get 'logout' => 'user_sessions#destroy', as: :logout

  root to: 'home#index'

  #mount Resque::Server.new, :at => "/resque", :constraints => lambda { |request|
  #  current_user.is_admin?
  #}
end
