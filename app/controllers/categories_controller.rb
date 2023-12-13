class CategoriesController < ApplicationController
  before_action :load_categories, only: %i(index show)
  before_action :load_category, only: %i(show)
  def index
    @pagy, @products = pagy Product.all, items: Settings.digits_8
    filter_and_sort_products
  end

  def show
    @pagy, @products = pagy @category.products, items: Settings.digits_8
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
    @products = @products.send(params[:sort_by]) if params[:sort_by].present?
    @pagy, @products = pagy @products.sort_by_name, items: Settings.digits_8
  end
end
