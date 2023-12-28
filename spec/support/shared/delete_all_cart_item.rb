RSpec.shared_examples "delete all cart items" do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, email: "other@example.com") }
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }

  before {
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    session[:cart] = []
   }

   describe "#delete_all_item" do
    it "deletes all cart items for the current user" do
      session[:cart] = [
        { "user_id" => user.id, "product_id" => product.id },
        { "user_id" => other_user.id, "product_id" => product.id }
      ]

      controller.send(:delete_all_item)

      expect(session[:cart].size).to eq(1)
      expect(session[:cart].first["user_id"]).not_to eq(user.id)
    end
  end
end
