Rails.application.routes.draw do

  get 'search/index'

  resources :chats
  resources :messages

  root 'top#index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
end
