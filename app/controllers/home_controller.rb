class HomeController < ApplicationController
  def index
    @categories = Category.includes(:products).sort_by_name
    return if @categories

    flash[:error] = t("alert.error_category")
    redirect_to root_path
  end
end
