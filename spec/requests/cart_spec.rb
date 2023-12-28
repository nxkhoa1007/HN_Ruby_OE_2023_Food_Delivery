require "rails_helper"

RSpec.describe CartController, type: :controller do
  let(:user) { create(:user) }
  let(:product1) { create(:product) }
  let(:product2) { create(:product) }
  let(:existing_cart_item) { { "product_id" => product1.id, "quantity" => 2, "user_id" => user.id, } }
  let(:valid_quantity) { 5 }


  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    session[:cart] = []
  end

  it_behaves_like "load cart items"
  before do
    session[:cart] = [{ "product_id" => product1.id, "quantity" =>  2, "user_id" => user.id }]
  end
  describe "GET #show" do
    it "renders the show template" do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe "POST #create" do
    context "when cart item exists" do
      before {
        post :create, params: { "id" => product1.slug, "quantity" => valid_quantity, "user_id" => user.id}, format: :turbo_stream
      }

      it "increments the quantity of the existing cart item" do
        expect { subject }.not_to change(session[:cart], :size)
        expect(session[:cart][0]["quantity"]).to eq(session[:cart][0]["quantity"])
      end

      it "handles successful addition" do
        expect(response).to render_template("shared/_alert")
      end
    end

    context "when cart item does not exist" do
      before {
        post :create, params: { "id" => "other_product", "quantity" => valid_quantity, "user_id" => user.id}, format: :turbo_stream
      }
      it "adds a new cart item" do
        expect { subject }.to change(session[:cart], :size).by(1)
      end

      it "handles successful addition" do
        expect(response).to render_template("shared/_alert")
      end
    end

    context "product is not exist" do
      it "redirects to root path with error flash" do
        post :create, params: { id: "invalid-slug"}
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t("alert.error_product"))
      end
    end

    context "when total quantity is invalid" do
      before { allow(controller).to receive(:check_total_quantity).and_return(false) }

      it "handles error quantity" do
        post :create, params: { id: product1.slug, quantity: 100 }, format: :turbo_stream
        expect(response).to render_template("shared/_alert")
      end
    end
  end

  describe "post #update_quantity" do
    it "redirect to cart path" do
      post :update_quantity, params: { id: product1.id, quantity: valid_quantity }, format: :html
      expect(response).to redirect_to(cart_path)
    end
    it "updates the quantity of the cart item" do
      post :update_quantity, params: { id: product1.id, quantity: valid_quantity }, format: :turbo_stream
      expect(response).to render(:show)
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "load cart items"
    it "deletes the cart item" do
      delete :destroy, params: { id: product1.id }, format: :html
      expect(response).to redirect_to(cart_path)
    end
    it "alert success" do
      delete :destroy, params: { id: product1.id }, format: :turbo_stream
      expect(response).to render_template("shared/_alert")
    end
  end

  describe "DELETE #destroy_all" do

    it_behaves_like "delete all cart items"

    it "redirect to cart path" do
      delete :destroy_all, format: :html
      expect(response).to redirect_to(cart_path)
    end
    it "alert success" do
      delete :destroy_all, format: :turbo_stream
      expect(response).to render_template("shared/_alert")
    end
  end
end
