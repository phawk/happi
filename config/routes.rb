Rails.application.routes.draw do
  devise_for :users

  resources :teams, only: %i[new create]

  root to: "dashboard#show"
end
