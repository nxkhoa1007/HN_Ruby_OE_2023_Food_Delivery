class SessionsController < ApplicationController
  def new
    return unless logged_in?

    redirect_to root_path
  end

  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user&.authenticate(params[:session][:password])
      check_activated_user user
    else
      flash.now[:error] = t("text.invalid_email_password")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  def check_activated_user user
    if user.activated
      reset_session
      if params[:session][:remember_me] == Settings.remember_checked
        remember(user)
      else
        forget(user)
      end
      log_in user
    else
      flash[:error] = t("text.account_not_activated")
      render :new, status: :unprocessable_entity
    end
  end
end
