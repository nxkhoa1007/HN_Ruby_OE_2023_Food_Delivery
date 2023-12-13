class ProductsController < ApplicationController
  before_action :load_product, only: %i(show)

  def show
    @category = Category.friendly.find(params[:category_id])
    @products_related = @category.products.includes(:category)
                                 .exclude_current(@product.id)
    return if @category

    flash[:danger] = t("alert.error_category")
    redirect_to root_path
  end

  private

  def load_product
    @product = Product.friendly.find params[:id]
    return if @product

    flash[:danger] = t("alert.error_product")
    redirect_to root_path
  end
end
