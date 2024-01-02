class OrdersController < ApplicationController
  before_action :check_login, :load_user_info
  before_action :load_order, only: %i(update)
  before_action :check_status_order, only: %i(update)
  after_action :delete_session, only: %i(create)
  def index
    @pagy, @orders = pagy Order.includes(:order_items)
                               .current_user_orders(current_user.id).newest,
                          items: Settings.digit_6
  end

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

  def select_info
    @user_infos = current_user.user_infos.default_info_list
  end

  def update_info
    session[:selected_address] = params[:selected_address]
    respond_to do |format|
      format.html{redirect_to checkout_path}
      load_user_info
      turbo_stream.replace("user-info", partial: "user_info",
        locals: {user_info: @user_info})
    end
  end

  def update
    if @order.cancel_order
      flash[:success] = t("alert.cancel_sucsess")
      redirect_to orders_path
    else
      flash[:error] = t("alert.error")
      render :index, status: :unprocessable_entity
    end
  end

  def order_params
    params.require(:order)
          .permit :type_payment, :note
  end

  private

  def load_user_info
    @user_info = if session[:selected_address]
                   UserInfo.find_by id: session[:selected_address]
                 else
                   current_user.user_infos.default_info.first
                 end
  end

  def delete_session
    session.delete(:selected_address)
  end

  def check_status_order
    return if @order.status.to_sym == :processing

    flash[:error] = t("alert.cancel_fail")
    redirect_to orders_path
  end

  def create_order_item
    @cart_items.each do |cart_item|
      product = Product.find(cart_item["product_id"])
      @order_item = @order.order_items.new(
        product_id: product.id,
        quantity: cart_item["quantity"],
        cost: cart_item["price"]
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

  def load_order
    @order = Order.includes(:order_items).find_by id: params[:id]
    return if @order

    flash[:error] = t("error")
    redirect_to orders_path
  end
end
