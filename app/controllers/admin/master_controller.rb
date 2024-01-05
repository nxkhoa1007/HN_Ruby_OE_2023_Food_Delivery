class Admin::MasterController < ApplicationController
  layout "admin/layouts/master"
  before_action :authenticate_user!
  before_action :admin_user
end
