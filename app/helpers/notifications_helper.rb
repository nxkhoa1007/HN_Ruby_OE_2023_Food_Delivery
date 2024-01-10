module NotificationsHelper
  def unread_noti notification
    notification.read_at? ? "" : "fw-bold text-primary"
  end
end
