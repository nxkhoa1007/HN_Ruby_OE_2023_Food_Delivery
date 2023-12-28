class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: %i(create)
  before_action :check_quantity, only: %i(update_quantity create)
  before_action :load_cart_item, only: %i(update_quantity destroy)
  def show; end

  def create
    if existing_item = find_cart_item(@product.id)
      if check_total_quantity(existing_item)
        increment_quantity(existing_item)
        handle_successful_addition
      else
        handle_error_quantity
      end
    else
      add_new_item(@product)
      handle_successful_addition
    end
  end

  def update_quantity
    @cart_item["quantity"] = params[:quantity].to_i
    load_cart
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.turbo_stream do
        render turbo_stream: [
          update_total_item_value,
          update_total_cart_value
        ]
      end
    end
  end

  def destroy
    session[:cart].delete(@cart_item)
    load_cart
    respond_to do |format|
      format.html{redirect_to cart_path, notice: t("alert.cart_add_success")}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("user_cart_items", @cart_items.size),
          turbo_stream.update("cart_view", partial: "cart/cart"),
          delete_success_alert,
          update_total_cart_value
        ]
      end
    end
  end

  def destroy_all
    delete_all_item
    load_cart
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("user_cart_items", @cart_items.size),
          turbo_stream.update("cart_view", partial: "cart/cart"),
          delete_success_alert,
          update_total_cart_value
        ]
      end
    end
  end

  private

  def find_product
    @product = Product.friendly.find_by slug: params[:id]
    return if @product

    flash[:error] = t("alert.error_product")
    redirect_to root_path
  end

  def increment_quantity cart_item
    cart_item["quantity"] += params[:quantity].to_i
  end

  def add_new_item product
    session[:cart] << {
      "user_id" => current_user.id,
      "product_id" => product.id,
      "product_image" => url_for(product.image),
      "product_name" => product.name,
      "quantity" => params[:quantity].to_i,
      "price" => product.cost
    }
  end

  def check_quantity
    return unless params[:quantity].to_i <
                  Settings.digit_1 || params[:quantity].to_i > Settings.digit_99

    handle_error_quantity
  end

  def check_total_quantity existing_item
    true unless (existing_item["quantity"] + params[:quantity].to_i) <
                Settings.digit_1 || (existing_item["quantity"] +
                  params[:quantity].to_i) > Settings.digit_99
  end

  def update_total_cart_value
    turbo_stream.update("subtotal", view_context
      .subtotal_cart_value(@cart_items))
  end

  def update_total_item_value
    turbo_stream.update("subtotal_item_#{@cart_item['product_id']}",
                        view_context
                        .format_cost(@cart_item["quantity"] *
                        @cart_item["price"]))
  end

  def delete_success_alert
    turbo_stream.append("body", partial: "shared/alert",
            locals: {message: t("alert.cart_delete_success"), type: "success"})
  end

  def load_cart_item
    @cart_item = find_cart_item(params[:id].to_i)
    return if @cart_item

    flash[:error] = t("alert.error_cart_item")
    redirect_to root_path
  end

  def find_cart_item product_id
    session[:cart].find do |item|
      item["product_id"] == product_id && item["user_id"] == current_user.id
    end
  end

  def handle_successful_addition
    load_cart
    respond_to do |format|
      format.html{redirect_back(fallback_location: root_path)}
      format.turbo_stream do
        render_turbo_stream_success
      end
    end
  end

  def handle_error_quantity
    respond_to do |format|
      format.html{redirect_back(fallback_location: root_path)}
      format.turbo_stream do
        render_turbo_stream_error_quantity
      end
    end
  end

  def render_turbo_stream_success
    render turbo_stream: [
      turbo_stream.update("user_cart_items", @cart_items.size),
      turbo_stream.append("body", partial: "shared/alert",
            locals: {message: t("alert.cart_add_success"), type: "success"})
    ]
  end

  def render_turbo_stream_error_quantity
    render turbo_stream: [
      turbo_stream.append("body", partial: "shared/alert", locals:
            {message: t("alert.error_quantity"), type: "error"})
    ]
  end
end
