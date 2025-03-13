class Users::RegistrationsController < Devise::RegistrationsController
  def create
    person = nil
    if sign_up_params[:username].present?
      person = Person.find_by(username: sign_up_params[:username])
    end

    if person
      build_resource(sign_up_params.merge(person: person))
    else
      person = Person.create!(
        status: "pending",
        address: Address.create!
      )
      build_resource(sign_up_params.merge(person: person))
    end

    resource.save
    yield resource if block_given?
    if resource.persisted?
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
