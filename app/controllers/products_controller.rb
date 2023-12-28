class ProductsController < ApplicationController
  before_action :load_product, only: %i(show)
  before_action :product_query, only: %i(index suggestions)

  def index; end

  def show
    @category = Category.friendly.find_by(slug: params[:category_id])
    if @category
      @pagy, @products = pagy_countless @category
                         .products.includes(:category)
                         .exclude_current(@product.id),
                                        items: Settings.digit_4
      render "shared/scrollable_list" if params[:page]
    else
      flash[:error] = t("alert.error_category")
      redirect_to root_path
    end
  end

  def suggestions
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update("suggestions", partial: "shared/suggestions",
                              locals: {results: @products})
      end
    end
  end

  private

  def product_query
    @products = if params[:query].blank?
                  Product.sort_by_name
                else
                  Product.search_by_name(params[:query]).sort_by_name
                end
  end

  def load_product
    @product = Product.includes(:ratings).friendly.find_by(slug: params[:id])
    if @product
      @rating_pagy, @ratings = pagy @product.ratings, items: Settings.digit_5,
      page_param: :_page
    else
      flash[:error] = t("alert.error_product")
      redirect_to root_path
    end
  end
end
