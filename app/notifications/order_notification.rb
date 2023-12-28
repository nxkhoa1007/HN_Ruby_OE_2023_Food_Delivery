# To deliver this notification:
#
# OrderNotification.with(post: @post).deliver_later(current_user)
# OrderNotification.with(post: @post).deliver(current_user)

class OrderNotification < Noticed::Base
  deliver_by :database

  def message
    t(".message")
  end

  def url
    admin_order_path(params[:order])
  end
end
