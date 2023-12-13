class Admin::MasterController < ApplicationController
  layout "admin/layouts/master"
  before_action :admin_user
end
