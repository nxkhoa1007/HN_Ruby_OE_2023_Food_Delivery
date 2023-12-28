require "rails_helper"
include ApplicationHelper
include NotificationsHelper
include RatingsHelper
RSpec.describe HomeController, type: :controller do
  context "when page parameter is not present" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @pagy and @products" do
      get :index
      expect(assigns(:pagy)).to be_a(Pagy)
      expect(assigns(:products)).to eq(Product.newest.limit(Settings.digit_8))
    end
  end

  context "when page parameter is present" do
    it "renders the shared/scrollable_list template" do
      get :index, params: { page: 1 }
      expect(response).to render_template("shared/scrollable_list")
    end
  end
end
