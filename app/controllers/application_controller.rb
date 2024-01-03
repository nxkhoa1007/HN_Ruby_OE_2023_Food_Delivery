class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale, :load_cart
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: User::ADDED_ATTRIBUTES
    devise_parameter_sanitizer.permit :account_update,
                                      keys: User::ADDED_ATTRIBUTES
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def admin_user
    redirect_to root_path unless current_user.role.to_sym == :admin
  end

  def check_login
    return if logged_in?

    store_location
    redirect_to login_path
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

    flash[:error] = t("alert.error_cart")
    redirect_to root_path
  end

  def delete_all_item
    session[:cart].reject!{|item| item["user_id"] == current_user.id}
  end
end
