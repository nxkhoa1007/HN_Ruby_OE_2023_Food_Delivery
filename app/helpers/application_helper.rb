module ApplicationHelper
  include Pagy::Frontend
  def full_title page_title = ""
    base_title = t("text.title")
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def switch_locale locale = I18n.locale.to_s.downcase
    locale == "en" ? "vi" : "en"
  end

  def language_info locale = I18n.locale.to_s.downcase
    {locale.to_sym => "admin/#{locale}.png"}
  end

  def display_error object, attribute
    return unless object.errors.include?(attribute)

    content_tag(:small,
                object.errors.full_messages_for(attribute)[0],
                class: "text-danger")
  end

  def format_cost cost
    "₫#{number_with_delimiter(cost, delimiter: '.', separator: ',')}"
  end

  def subtotal_cart_value cart_items
    subtotal_value = Settings.digit_0

    cart_items.each do |item|
      subtotal_value += item["price"] * item["quantity"]
    end

    format_cost(subtotal_value)
  end

  def format_status status
    content_tag(:span, status_text(status), class: status_class(status))
  end

  def format_time time
    time.strftime("%d-%m-%Y %H:%M:%S")
  end

  def display_order_status status
    status_mappings = {
      processing: t("text.order.status_processing"),
      confirmed: t("text.order.status_confirmed"),
      shipping: t("text.order.status_shipping"),
      delivered: t("text.order.status_delivered"),
      canceled: t("text.order.status_canceled")
    }
    status_mappings.fetch(status.to_sym, t("text.order.status_canceled"))
  end

  def display_type_payment type_payment
    if type_payment.to_sym == :cod
      t("text.cod")
    else
      t("text.bank")
    end
  end

  def order_total order
    total_value = order.reduce(0){|a, e| a + e.quantity * e.cost}
    format_cost(total_value)
  end

  def status_text status
    status == Settings.status_in ? t("text.available") : t("text.unavailable")
  end

  def status_class status
    status == Settings.status_in ? "text-success" : "text-danger"
  end

  def path_for_sorting sort_by:
    if @category.present?
      category_path(@category, sort_by:)
    else
      categories_path(sort_by:)
    end
  end
end
