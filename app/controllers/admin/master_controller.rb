class Admin::MasterController < ApplicationController
  layout "admin/layouts/master"
  before_action :authenticate_user!
  before_action :admin_user, :load_notifications

  private
  def load_notifications
    @noti_pagy, @notifications = pagy_countless Notification.all.newest,
                                                items: Settings.page_11,
                                                page_param: :noti_page
    @unread_notifications = Notification.unread_noti
    render "admin/shared/scrollable_noti" if params[:noti_page]
  end
end
