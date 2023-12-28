class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_locale, :load_cart
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email,
      :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def admin_user
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

    flash[:error] = t("alert.error_cart")
    redirect_to root_path
  end

  def delete_all_item
    session[:cart].reject!{|item| item["user_id"] == current_user.id}
  end
end
