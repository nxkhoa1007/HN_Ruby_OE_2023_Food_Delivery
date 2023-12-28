require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_info) { create(:user_info, user: user) }
  let(:product) { create(:product) }
  let(:cart_items) { [{ "product_id" => product.id, "quantity" => 2, "price" => product.cost }] }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    session[:cart] = cart_items
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) do
        {
          order: {
            type_payment: :cod,
            user_info_attributes: {user_id: user.id, name: "John Doe", phoneNum: "0385079001", address: "Test Address" },
            order_items_attributes: [{ product_id: product.id, cost: product.cost, quantity: 2,}]
          }
        }
      end

      it "creates a new order" do
        expect { post :create, params: valid_params }.to change(Order, :count).by(1)
      end

      it "redirects to root path" do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it_behaves_like "delete all cart items"
    end

    context "with invalid params" do
      let(:invalid_params) { { order: {user_info_attributes: { name: ""}} } }

      it "does not create a new order" do
        expect { post :create, params: invalid_params }.not_to change(Order, :count)
      end

      it "renders the new template with status :unprocessable_entity" do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #select_info" do
    it "renders the select_info template" do
      get :select_info
      expect(response).to render_template(:select_info)
    end
  end

  describe "PUT #update_info" do
    let(:selected_address) { create(:user_info, user: user).id }

    it "redirects to checkout path for HTML format" do
      put :update_info, params: { selected_address: selected_address }
      expect(response).to redirect_to(checkout_path)
    end
  end

  describe "PUT #update" do
    let(:order) { create(:order, user: user, user_info: user_info) }

    context "with processing order status" do
      before { order.status = :processing }
      it "cancels the order" do
        put :update, params: { id: order.id }
        expect(order.reload.status.to_sym).to eq(:canceled)
      end

      it "redirects to orders path" do
        put :update, params: { id: order.id }
        expect(response).to redirect_to(orders_path)
      end
    end

    context "with not processing order status" do
      before {
        order.status = :delivered
        order.save!
      }
      it "does not cancel the order" do
        put :update, params: { id: order.id }
        expect(order.status.to_sym).not_to eq(:canceled)
      end

      it "redirect to orders path" do
        put :update, params: { id: order.id }
        expect(flash[:error]).to eq(I18n.t("alert.cancel_fail"))
        expect(response).to redirect_to (orders_path)
      end
    end
  end
end
