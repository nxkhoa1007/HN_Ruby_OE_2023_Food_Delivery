require "support/admin_shared"
RSpec.describe Admin::ProductsController, type: :controller do
  let(:valid_product_params) { attributes_for(:product) }
  let(:invalid_product_params) { attributes_for(:product, name: nil) }
  let(:product) { create(:product) }
  let(:admin){create(:user, role: :admin)}

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end
  describe "GET #index" do
    it_behaves_like "shared admin controller"
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "loads products with pagination" do
      create_list(:product, 12)
      get :index
      expect(assigns(:products).count).to eq(10)
      expect(assigns(:pagy)).to be_present
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "assigns a new product" do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new product" do
        expect {
          post :create, params: { product: valid_product_params }
        }.to change(Product, :count).by(1)
      end

      it "redirects to the admin products path" do
        post :create, params: { product: valid_product_params }
        expect(flash[:success]).to eq(I18n.t("alert.product_add_successful"))
        expect(response).to redirect_to(admin_products_path)
      end
    end

    context "with invalid params" do
      it "does not create a new product" do
        expect {
          post :create, params: { product: invalid_product_params }
        }.to_not change(Product, :count)
      end

      it "renders the new template with unprocessable_entity status" do
        post :create, params: { product: invalid_product_params }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: product.slug }
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the product" do
        put :update, params: { id: product.slug, product: valid_product_params }
        product.reload
        expect(product.name).to eq(valid_product_params[:name])
      end

      it "redirects to the admin products path" do
        put :update, params: { id: product.slug, product: valid_product_params }
        expect(response).to redirect_to(admin_products_path)
      end
    end

    context "with invalid params" do
      it "does not update the product" do
        put :update, params: { id: product.slug, product: invalid_product_params }
        product.reload
        expect(product.name).not_to eq(invalid_product_params[:name])
      end

      it "renders the edit template with unprocessable_entity status" do
        put :update, params: { id: product.slug, product: invalid_product_params }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the product" do
      product_to_delete = create(:product)
      expect {
        delete :destroy, params: { id: product_to_delete.slug }
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the admin products path" do
      delete :destroy, params: { id: product.slug }
      expect(response).to redirect_to(admin_products_path)
    end
  end
end
