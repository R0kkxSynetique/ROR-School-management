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

    namespace :dean do
      resources :specializations do
        member do
          patch :archive
          patch :unarchive
        end
      end

      resources :schedules

      resources :report_cards, only: [ :index ] do
        collection do
          post :generate
        end
      end

      resources :sections
    end

    # Course management
    get "dean/courses/new", to: "dean#new_course", as: "dean_new_course"
    post "dean/courses", to: "dean#create_course", as: "dean_create_course"
    get "dean/courses/:course_id/edit", to: "dean#edit_course", as: "dean_edit_course"
    patch "dean/courses/:course_id", to: "dean#update_course", as: "dean_update_course"
    patch "dean/courses/:course_id/archive", to: "dean#archive_course", as: "dean_archive_course"
    patch "dean/courses/:course_id/unarchive", to: "dean#unarchive_course", as: "dean_unarchive_course"

    # Teacher management
    get "dean/teachers", to: "dean#teachers_index", as: "dean_teachers"
    get "dean/teachers/new", to: "dean#new_teacher", as: "dean_new_teacher"
    post "dean/teachers", to: "dean#create_teacher", as: "dean_create_teacher"
    get "dean/teachers/:id/edit", to: "dean#edit_teacher", as: "dean_edit_teacher"
    patch "dean/teachers/:id", to: "dean#update_teacher", as: "dean_update_teacher"
    delete "dean/teachers/:id", to: "dean#delete_teacher", as: "dean_delete_teacher"

    # School Classes management
    get "dean/school_classes", to: "dean#school_classes_index", as: "dean_school_classes"
    get "dean/new_class", to: "dean#new_class", as: "dean_new_class"
    post "dean/create_class", to: "dean#create_class", as: "dean_create_class"
    get "dean/edit_class/:id", to: "dean#edit_class", as: "dean_edit_class"
    patch "dean/update_class/:id", to: "dean#update_class", as: "dean_update_class"
    delete "dean/delete_class/:id", to: "dean#delete_class", as: "dean_delete_class"

    get "dean/assign_specialization", to: "dean#new_specialization_assignment", as: "dean_new_specialization"
    post "dean/assign_specialization", to: "dean#assign_specialization", as: "dean_assign_specialization"

    get "dean/assign_student/:school_class_id", to: "dean#new_student_assignment", as: "dean_new_student"
    post "dean/assign_student/:school_class_id", to: "dean#assign_student", as: "dean_assign_student"
    delete "dean/school_classes/:school_class_id/remove_student/:student_id", to: "dean#remove_student", as: "dean_remove_student"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
