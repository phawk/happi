Rails.application.routes.draw do
  namespace :admin do
    resources :teams
    resources :users
    resources :custom_email_addresses
    resources :beta_signups

    root to: "teams#index"
  end

  namespace :events do
    post "/postmark", to: "postmark_webhooks#create"
  end

  devise_for :users

  authenticate :user, ->(u) { u.role?(:admin) } do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :beta_signups, only: :create
  resources :custom_email_addresses, only: %i[create destroy]
  resources :customers do
    post "block", on: :member
    post "unblock", on: :member
  end
  resources :message_threads, only: %i[index show new create update destroy], path: "threads" do
    post :merge_with_previous, on: :member
    resources :messages, only: %i[new create] do
      get :hovercard, on: :member
    end
  end
  resources :teams, only: %i[index new create edit update] do
    post :change, on: :member
    put :logo_upload, on: :member
  end
  resource :settings, only: %i[show update]
  get "/join/:code", to: "team_invites#new", as: :join_team
  post "/join/:code", to: "team_invites#create"
  put "/join/:code", to: "team_invites#update"

  get "/dashboard", to: "dashboard#show"
  get "/terms", to: "pages#terms"
  get "/privacy", to: "pages#privacy"
  get "/security", to: "pages#security"

  root to: "pages#home"
end
