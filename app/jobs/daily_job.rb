class DailyJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    NotificationMailer.daily_order.deliver_later
  end
end
