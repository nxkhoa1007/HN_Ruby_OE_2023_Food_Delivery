class CategoriesController < ApplicationController
  before_action :load_categories, only: %i(index show)
  before_action :load_category, only: %i(show)
  def index
    @pagy, @products = pagy Product.all, items: Settings.digit_8
    filter_and_sort_products
  end

  def show
    @products = @category.products
    filter_and_sort_products
    render :index
  end

  private

  def load_categories
    @categories = Category.sort_by_name
  end

  def load_category
    @category = Category.friendly.find_by(slug: params[:id])
    return if @category

    flash[:error] = t("alert.error_category")
    redirect_to root_path
  end

  def filter_and_sort_products
    @pagy, @products = pagy(
      @products.public_send(params[:sort_by] || :sort_by_name),
      items: Settings.digit_8
    )
  end
end
