class Admin::MasterController < ApplicationController
  layout "admin/layouts/master"

  before_action :admin_user

  private
  def admin_user
    redirect_to root_path unless current_user.role.to_sym == :admin
  end
end
