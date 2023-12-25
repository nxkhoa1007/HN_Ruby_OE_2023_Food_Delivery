class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale, :load_cart, :admin_user

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def admin_user
    return unless logged_in?

    redirect_to root_path unless current_user.role.to_sym == :admin
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_cart
    session[:cart] ||= []
    @cart_items = session[:cart].select do |item|
      item["user_id"] == current_user.id
    end
    return if @cart_items

    flash[:danger] = t("alert.error_cart")
    redirect_to root_path
  end

  def delete_all_item
    session[:cart].reject!{|item| item["user_id"] == current_user.id}
  end
end
