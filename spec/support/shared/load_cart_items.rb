RSpec.shared_examples "load cart items" do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, email: "other@example.com") }
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }

  before {
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    session[:cart] = []
   }

  describe "#load_cart" do
    it "loads the cart items for the current user" do
      session[:cart] = [
        { "user_id" => user.id, "product_id" => product.id },
        { "user_id" => other_user.id, "product_id" => product.id }
      ]
      controller.send(:load_cart)
      expect(assigns(:cart_items).size).to eq(1)
      expect(assigns(:cart_items).first["user_id"]).to eq(user.id)
    end
  end
end
