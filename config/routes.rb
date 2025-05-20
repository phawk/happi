Rails.application.routes.draw do
  namespace :admin do
    resources :teams do
      post :verified_email
    end
    resources :users do
      post :sync
    end
    resources :custom_email_addresses
    resources :beta_signups
    resources :changelogs
    resources :site_options

    root to: "teams#index"
  end

  namespace :events do
    post "/postmark", to: "postmark_webhooks#create"
  end

  namespace :api, format: :json do
    scope path: ":team_publishable_key" do
      resources :customers, only: :create
      resources :messages, only: :create
    end
  end

  devise_for :users, controllers: {
    registrations: "user_registrations",
    masquerades: "admin/masquerades",
  }

  authenticated :user, ->(u) { u.role?(:admin) } do
    mount Sidekiq::Web => "/sidekiq"
    mount Blazer::Engine, at: "blazer"
    mount Lookbook::Engine, at: "/lookbook"
  end

  # Stripe webhooks
  mount StripeEvent::Engine, at: "/events/stripe"

  resources :beta_signups, only: :create
  namespace :billing do
    resource :subscriptions, path: "subscription", only: %i[show create]
    get :success, to: "subscriptions#success"
    post :manage, to: "subscriptions#manage"
  end
  resources :blocked_domains, only: %i[create destroy]
  resources :canned_responses, only: %i[new create edit update destroy]
  resources :custom_email_addresses, only: %i[create destroy]
  resources :customers do
    get "search", on: :collection
    post "block", on: :member
    post "unblock", on: :member
  end
  resources :knowledge_base, only: [:index, :create, :show, :destroy], path: "knowledge-base"
  resources :message_threads, only: %i[index show new create update destroy], path: "threads" do
    get :search, on: :collection
    get :spam, on: :collection
    get :blocked, on: :collection
    post :merge_with_previous, on: :member
    delete :auto_archive, on: :collection
    resource :generate_reply, only: :create, controller: "ai/generate_reply", as: :ai_generate_reply
    resources :messages, only: %i[new create update] do
      get :hovercard, on: :member
      get :raw_source, on: :member
      get :original_html, on: :member
      get :context, on: :member

      resource :spam_check, only: :create, controller: "messages/spam_checks"
    end
  end
  resources :teams, only: %i[index new create edit update] do
    post :change, on: :member
    put :logo_upload, on: :member
  end
  resources :team_users, only: %i[update destroy]
  resource :settings, only: %i[show] do
    get :team
    get :emails
    get :canned_responses
    get :widget
    get :billing
    get :blocked_domains
    get :spam
    put :spam_update
  end
  namespace :image_uploads do
    resources :logo, controller: "logo", only: :show
  end
  get "/join/:code", to: "team_invites#new", as: :join_team
  post "/join/:code", to: "team_invites#create"
  put "/join/:code", to: "team_invites#update"
  get "/view_message/:id", to: "messages#view_message", as: :view_message

  get "/dashboard", to: "dashboard#show"
  get "/auth/check", to: "auth#check"

  root to: "dashboard#show"
end
