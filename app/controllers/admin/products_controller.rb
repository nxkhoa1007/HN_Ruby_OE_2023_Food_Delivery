class Admin::ProductsController < Admin::MasterController
  before_action :load_product, except: %i(index new create)
  def index
    @q = Product.ransack(params[:q])
    @pagy, @products = pagy @q.result, items: Settings.page_10
    store_location
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params

    @product.image.attach params.dig(:product, :image)
    if @product.save
      flash[:success] = t("alert.product_add_successful")
      redirect_back_or session[:forwarding_url] || admin_products_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update product_params
      flash[:success] = t("alert.product_update_successful")
      redirect_back_or session[:forwarding_url] || admin_products_path
    else
      flash[:error] = t("alert.error")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t("alert.product_delete_successful")
    else
      flash[:error] = t("alert.error")
    end
    redirect_back_or session[:forwarding_url] || admin_products_path
  end

  def product_params
    params.require(:product)
          .permit :name, :cost,
                  :description, :category_id, :image, :status
  end

  private

  def load_product
    @product = Product.friendly.find_by(slug: params[:id])
    return if @product

    flash[:danger] = t("error")
    redirect_to admin_products_path
  end
end
