Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords: "devise/passwords",
    sessions: "devise/sessions",
    registrations: "users/registrations"
  }

  resources :courses, only: [ :index, :show ]
  resources :school_classes, only: [ :show ]

  namespace :users do
    resources :grades, only: [ :index ]
    resources :examinations do
      resources :grades, controller: "teacher_grades", except: [ :show ]
    end

    # Dean specific routes
    get "dean/dashboard", to: "dean#dashboard", as: "dean_dashboard"
    get "dean/new_class", to: "dean#new_class", as: "dean_new_class"
    post "dean/create_class", to: "dean#create_class", as: "dean_create_class"

    get "dean/assign_specialization", to: "dean#new_specialization_assignment", as: "dean_new_specialization"
    post "dean/assign_specialization", to: "dean#assign_specialization", as: "dean_assign_specialization"

    get "dean/assign_student/:school_class_id", to: "dean#new_student_assignment", as: "dean_new_student"
    post "dean/assign_student/:school_class_id", to: "dean#assign_student", as: "dean_assign_student"

    post "dean/archive_course/:course_id", to: "dean#archive_course", as: "dean_archive_course"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
