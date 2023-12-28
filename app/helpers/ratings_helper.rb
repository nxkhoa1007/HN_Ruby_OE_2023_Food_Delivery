module RatingsHelper
  def average_rating ratings
    (ratings.reduce(0){|a, e| a + e.rating} / ratings.size)
      .round(Settings.digit_1)
  end

  def check_all_rated order_items
    order_items.all?(&:rated?)
  end
end
