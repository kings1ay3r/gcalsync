Rails.application.routes.draw do
  root "sessions#new"

  # Registration routes
  get "register", to: "registrations#new"
  post "register", to: "registrations#create"

  # Sessions routes
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "sign_out", to: "sessions#destroy", as: "sign_out"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  post "webhooks/calendar", to: "webhooks#calendar"

  # Defines the root path route ("/")

  scope constraints: ->(request) { request.session[:user_id].present? } do
    resources :calendars, only: [ :index ]
    get "google_calendar/connect", to: "google_calendars#connect", as: "google_connect"
    get "sync_events", to: "google_calendars#sync_events"
    get "oauth2callback", to: "google_calendars#callback"
    # Add more routes as needed
  end
end
