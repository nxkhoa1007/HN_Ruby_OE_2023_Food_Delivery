class Users::SessionsController < Devise::SessionsController
  private
  def after_sign_in_path_for resource
    if resource.role.to_sym == :admin
      admin_root_path
    else
      super
    end
  end
end
