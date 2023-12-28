class NotificationMailer < ApplicationMailer
  def daily_order
    @order = Order.today
    User.admin_user.each do |admin|
      mail to: admin.email, subject: t("user_mailer.daily_notification.subject")
    end
  end
end
