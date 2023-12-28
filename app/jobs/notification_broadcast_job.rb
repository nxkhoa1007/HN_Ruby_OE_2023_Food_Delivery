class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform notification
    ActionCable.server.broadcast "notifications_channel",
                                 {counter: render_counter(
                                   Notification.unread_noti.size
                                 ),
                                  layout: render_notification(notification)}
  end

  private

  def render_counter counter
    ApplicationController.renderer.render(partial: "notifications/counter",
                                          locals: {counter:})
  end

  def render_notification notification
    ApplicationController.renderer.render(partial: "notifications/notification",
                                          locals: {notification:})
  end
end
