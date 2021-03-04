Rails.application.routes.draw do
  devise_for :users

  resources :customers
  resources :message_threads, only: %i[show], path: "threads"
  resources :teams, only: %i[new create]

  root to: "dashboard#show"
end
