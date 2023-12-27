class HomeController < ApplicationController
  def index
    @pagy, @products = pagy_countless Product.newest, items: Settings.digit_8
    render "shared/scrollable_list" if params[:page]
  end
end
