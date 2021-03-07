Rails.application.routes.draw do
  devise_for :users

  resources :customers
  resources :message_threads, only: %i[index show], path: "threads" do
    resources :messages, only: %i[new create]
  end
  resources :teams, only: %i[index new create] do
    post :change, on: :member
  end
  resource :settings, only: %i[show update]

  root to: "dashboard#show"
end
