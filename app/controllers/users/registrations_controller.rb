class Users::RegistrationsController < Devise::RegistrationsController
  protected
  def after_inactive_sign_up_path_for resource_name
    new_user_registration_path(resource_name)
  end
end
