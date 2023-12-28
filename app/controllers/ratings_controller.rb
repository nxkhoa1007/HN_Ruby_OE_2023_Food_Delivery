class RatingsController < ApplicationController
  before_action :authenticate_user!
  def new
    @rating = Rating.new
    @order = Order.find_by id: params[:id]
    @order_items = @order.order_items
  end

  def create
    @order_item = OrderItem.find_by id: params[:id]
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
