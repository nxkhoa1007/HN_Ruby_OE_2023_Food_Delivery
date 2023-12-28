class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user_info, except: %i(index)
  before_action :check_status_order, only: %i(update)
  after_action :delete_session, only: %i(create)
  def index
    @q = Order.includes(:order_items).current_user_orders(current_user.id)
              .ransack(params[:q])
    @pagy, @orders = pagy @q.result.newest,
                          items: Settings.page_10
  end

  def new
    @order = current_user.orders.new
    @order.build_user_info
    @order.order_items.build
  end

  def create
    @order = current_user.orders.new(order_params)
    if @order.save
      @order.save_order_code
      delete_all_item
      flash[:success] = t("alert.order_sucsess")
      redirect_to root_path
    else
      @order.order_items.destroy_all
      @order.order_items.build
      render :new, status: :unprocessable_entity
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
    end
  end

  def update
    @order.cancel_order
    flash[:success] = t("alert.cancel_sucsess")
    redirect_to orders_path
  end

  def order_params
    params.require(:order)
          .permit :type_payment, :note,
                  user_info_attributes: %i(user_id name phoneNum address),
                  order_items_attributes: %i(product_id cost quantity)
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
    @order = Order.includes(:order_items).find_by id: params[:id]
    return if @order.status.to_sym == :processing

    flash[:error] = t("alert.cancel_fail")
    redirect_to orders_path
  end
end
