module Admin::ProductsHelper
  def format_cost cost
    "₫#{number_with_delimiter(cost, delimiter: '.', separator: ',')}"
  end

  def status_text status
    status == Settings.status_in ? t("text.available") : t("text.unavailable")
  end
end
