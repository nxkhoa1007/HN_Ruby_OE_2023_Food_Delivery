class Users::ConfirmationsController < Devise::ConfirmationsController
  def after_confirmation_path_for resource_name, _resource
    new_session_path(resource_name)
  end
end
