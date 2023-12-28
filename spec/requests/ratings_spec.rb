require "rails_helper"
RSpec.describe RatingsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_info) { create(:user_info, user: user) }
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }
  let(:order) { create(:order, user: user, user_info: user_info) }
  let(:order_item) { create(:order_item, order: order, product: product) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #new" do
    it "assigns a new rating to @rating" do
      get :new, params: { id: order.id }
      expect(assigns(:rating)).to be_a_new(Rating)
    end

    it "assigns the order to @order" do
      get :new, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
    end

    it "assigns order items to @order_items" do
      get :new, params: { id: order.id }
      expect(assigns(:order_items)).to eq(order.order_items)
    end

    it "renders the new template" do
      get :new, params: { id: order.id }
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let(:valid_params) { { id: order_item.id, rating: { rating: 4, comment: "Nice!" } } }
    before do
      post :create, params: valid_params
    end
    context "with valid params" do
      it "creates a new rating" do
        expect do
          expect { subject }.to change(Rating, :count).by(1)
        end
      end

      it "assigns the created rating to @rating" do
        post :create, params: valid_params
        expect(assigns(:rating)).to be_a(Rating)
        expect(assigns(:rating).rating).to eq(4)
        expect(assigns(:rating).comment).to eq("Nice!")
      end

      it "rates the order item" do
        post :create, params: valid_params
        expect(order_item.rate).to be true
      end

      it "redirects to the previous page or root path for HTML format" do
        post :create, params: valid_params, format: :html
        expect(response).to render_template(:new)
      end

      it "renders a Turbo Stream response with updates for Turbo format" do
        post :create, params: valid_params, format: :html
        expect(response).to render_template(:new)
      end
    end

    context "with invalid params" do
      it "renders the new template" do
        post :create, params: { id: order_item.id, rating: { comment: "Invalid" } }
        expect(response).to render_template(:new)
      end

      it "sets an error flash message" do
        post :create, params: { id: order_item.id, rating: { comment: "Invalid" } }
        expect(flash[:error]).to eq(I18n.t("alert.error"))
      end
    end
  end
end
