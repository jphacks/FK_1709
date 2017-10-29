Rails.application.routes.draw do

  get 'mypage/show'

  get 'search' => 'search#index'

  get 'search/users/:id' => 'search#show'

  resources :chats
  resources :messages

  root 'top#index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
end
