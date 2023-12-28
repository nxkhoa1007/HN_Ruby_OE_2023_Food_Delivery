class OrderMailer < ApplicationMailer
  def order_confirm order
    @order = order
    mail to: @order.user.email,
         subject: t("user_mailer.order_notification.confirm",
                    order_code: order.order_code)
  end

  def order_success order
    @order = order
    mail to: @order.user.email,
         subject: t("user_mailer.order_notification.success",
                    order_code: order.order_code)
  end
end
