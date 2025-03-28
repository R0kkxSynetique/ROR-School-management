module RoleRedirectable
  extend ActiveSupport::Concern

  private

  def after_sign_in_path_for(resource)
    if resource.person.is_a?(Dean)
      users_dean_dashboard_path
    else
      super
    end
  end
end
