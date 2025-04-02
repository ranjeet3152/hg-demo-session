Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "articles#index"
  # root "patients#index"
  root "tasks#index"

  # namespace :dashboards do
  #   get 'active_sessions/index'
  #   # get 'revenues/index'
  #   get 'total_users/index'
  # end

  # resources :articles

  # resources :patients
  # resources :admissions
  # resources :appointments

  # namespace :departments do
  #   resources :appointments
  # end

  resources :tasks do
    member do
      patch :change_status
    end
  end
  
end
