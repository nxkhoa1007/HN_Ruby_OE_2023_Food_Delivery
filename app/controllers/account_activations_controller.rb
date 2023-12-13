class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit

  def edit
    if @user && !@user.activated
      @user.activate
      flash[:success] = t("alert.account_activated")
    else
      flash[:error] = t("alert.invalid_link")
    end
    redirect_to root_path
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:error] = t("alert.not_found_user")
    redirect_to root_path
  end
end
