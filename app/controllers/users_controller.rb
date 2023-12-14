class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:success] = t("alert.account_created_successful")
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user)
          .permit :name, :email,
                  :password, :password_confirmation,
                  :dob, :gender
  end
end
