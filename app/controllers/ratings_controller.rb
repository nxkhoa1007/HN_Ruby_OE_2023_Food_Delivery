class RatingsController < ApplicationController
  before_action :load_order, only: %i(new)
  before_action :load_order_item, only: %i(create)
  def new
    @rating = Rating.new
    @order_items = @order.order_items
  end

  def create
    @rating = current_user.ratings.new rating_params
    if @rating.save
      @order_item.rate
      handle_successful_rate
    else
      flash[:error] = t("alert.error")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:error] = t("alert.error_order")
    redirect_to root_path
  end

  def load_order_item
    @order_item = OrderItem.find_by id: params[:id]
    return if @order_items

    flash[:error] = t("alert.error_order_item")
    redirect_to root_path
  end

  def handle_successful_rate
    respond_to do |format|
      format.html{redirect_back(fallback_location: root_path)}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("rate_#{@order_item.id}",
                              partial: "ratings/button",
                              locals: {order_item: @order_item}),
          turbo_stream.append("body", partial: "shared/alert",
            locals: {message: t("alert.rate_product_success"),
                     type: "success"})
        ]
      end
    end
  end

  def rating_params
    params.require(:rating)
          .permit :rating, :comment, :product_id
  end
end
