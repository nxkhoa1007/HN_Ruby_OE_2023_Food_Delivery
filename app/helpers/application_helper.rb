module ApplicationHelper
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
end
