class OrdersController < ApplicationController
  before_action :check_login, :load_user_info
  def new
    @order = Order.new
  end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.new(order_params)
      @order.user_info = @user_info
      if @order.save
        @order.save_order_code
        create_order_item
        delete_all_item
        flash[:success] = t("alert.order_sucsess")
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
    rescue StandardError => e
      alert_error(e.message)
    end
  end

  def order_params
    params.require(:order)
          .permit :type_payment, :note
  end

  private
  def check_login
    return if logged_in?

    redirect_to login_path
  end

  def load_user_info
    @user_info = current_user.user_infos.default_info.first
  end

  def create_order_item
    @cart_items.each do |cart_item|
      product = Product.find(cart_item["product_id"])
      @order_item = @order.order_items.new(
        product_id: product.id,
        quantity: cart_item["quantity"]
      )
      @order_item.save!
    end
  end

  def alert_error text
    respond_to do |format|
      format.html{redirect_back(fallback_location: root_path)}
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.append("body", partial: "shared/alert", locals:
                {message: t("alert.error"), type: "error"})
      end
    end
    Rails.logger.error("Error: #{text}")
  end
end
