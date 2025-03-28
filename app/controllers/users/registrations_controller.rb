class Users::RegistrationsController < Devise::RegistrationsController
  def create
    person = nil
    if sign_up_params[:username].present?
      person = Person.find_by(username: sign_up_params[:username])
    end

    unless person
      set_flash_message! :alert, :person_not_found
      redirect_to new_user_registration_path
      return
    end

    if person.user.present?
      set_flash_message! :alert, :person_already_has_user
      redirect_to new_user_registration_path
      return
    end

    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?

    if resource.persisted?
      person.update!(user: resource)

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end
