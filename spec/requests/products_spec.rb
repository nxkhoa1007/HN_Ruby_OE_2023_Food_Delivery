require "rails_helper"
RSpec.describe ProductsController, type: :controller do
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }

  describe "GET #index" do
    context "without query parameter" do
      it "assigns all products to @products" do
        get :index
        expect(assigns(:products)).to eq(Product.sort_by_name)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "with query parameter" do
      it "assigns filtered products to @products" do
        query = "test"
        get :index, params: { query: query }
        expect(assigns(:products)).to eq(Product.search_by_name(query).sort_by_name)
      end
    end
  end

  describe "GET #show" do
    context "when product exists" do
      before { get :show, params: { id: product.slug, category_id: category.slug } }

      it "assigns the product to @product" do
        expect(assigns(:product)).to eq(product)
      end

      it "assigns related products to @products" do
        expect(assigns(:products)).to eq(category.products.exclude_current(product.id))
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "when product does not exist" do
      it "redirects to root path with error flash" do
        get :show, params: { id: "invalid-slug" ,category_id: "invalid-category-slug"}
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t("alert.error_product"))
      end
    end

    context "when category does not exist" do
      it "redirects to root path with error flash" do
        get :show, params: { id: product.slug, category_id: "invalid-category" }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(I18n.t("alert.error_category"))
      end
    end

    context "when page parameter is present" do
      it "renders the scrollable_list template" do
        get :show, params: { id: product.slug, category_id: category.slug, page: 1 }
        expect(response).to render_template("shared/scrollable_list")
      end
    end
  end

  describe "GET #suggestions" do
    it "renders a turbo_stream response with suggestions partial" do
      get :suggestions, format: :turbo_stream
      expect(response).to render_template("shared/_suggestions")
    end
  end
end
