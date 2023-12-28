class Users::RegistrationsController < Devise::RegistrationsController
  before_action :load_resource, only: %i(update_info update_password)
  def update_info
    if resource.update_without_password user_params
      flash[:success] = t("alert.update_success")
      redirect_back(fallback_location: root_path)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_password
    if resource.update_password password_params
      sign_out(resource)
      redirect_to root_path, notice: t("alert.update_success")
    else
      render :change, status: :unprocessable_entity
    end
  end

  def change
    self.resource = resource_class.new
  end
  private

  def load_resource
    self.resource = resource_class
                    .to_adapter.get!(send(:"current_#{resource_name}").to_key)
  end

  def password_params
    params.require(:user).permit(:current_password,
                                 :password, :password_confirmation)
  end

  def user_params
    params.require(:user)
          .permit :name, :avatar
  end

  protected

  def after_inactive_sign_up_path_for resource_name
    new_user_registration_path(resource_name)
  end
end
