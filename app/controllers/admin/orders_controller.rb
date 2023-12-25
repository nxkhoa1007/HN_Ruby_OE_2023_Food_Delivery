class Admin::OrdersController < Admin::MasterController
  before_action :load_order, only: %i(edit update)
  before_action :check_status_order, only: %i(update)
  def index
    @pagy, @orders = pagy Order.includes(:order_items).newest,
                          items: Settings.page_10
  end

  def edit; end

  def update
    if @order.update order_params
      flash[:success] = t("alert.order_update_successful")
      redirect_to admin_orders_path
    else
      flash[:error] = t("alert.error")
      render :edit, status: :unprocessable_entity
    end
  end

  def order_params
    params.require(:order)
          .permit :status
  end

  private
  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:error] = t("error")
    redirect_to admin_orders_path
  end

  def check_status_order
    return if [:delivered, :canceled].include?(@order.status.to_sym)

    flash[:error] = t("alert.cannot_update_delivered_order")
    redirect_to orders_path
  end
end
