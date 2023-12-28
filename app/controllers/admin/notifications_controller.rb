class Admin::NotificationsController < Admin::MasterController
  def index; end

  def read_all
    Notification.mark_as_read!
    respond_to do |format|
      format.html{redirect_back(fallback_location: root_path)}
      turbo_stream.update("notification-list", @notifications)
    end
  end

  def update
    @notification = Notification.find_by id: params[:id]
    return unless @notification

    @notification.mark_as_read!
    respond_to do |format|
      format.html{redirect_back(fallback_location: root_path)}
      turbo_stream.update("current-noti-#{@notification.id}",
                          partial: "notifications/notification",
                          locals: {notification: @notification})
    end
  end
end
