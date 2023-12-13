class CategoriesController < ApplicationController
  before_action :load_categories, only: %i(index show)

  def index
    @pagy, @products = pagy Product.all, items: Settings.digits_8
    filter_and_sort_products
  end

  def show
    begin
      @category = Category.friendly.find(params[:id])
      @pagy, @products = pagy @category.products, items: Settings.digits_8
      filter_and_sort_products
    end
    render :index
  end

  private

  def load_categories
    @categories = Category.all.sort_by_name
  end

  def filter_and_sort_products
    @products = @products.send(params[:sort_by]) if params[:sort_by].present?
    @pagy, @products = pagy @products.sort_by_name, items: Settings.digits_8
  end
end
