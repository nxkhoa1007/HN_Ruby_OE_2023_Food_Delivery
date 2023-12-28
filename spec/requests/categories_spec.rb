require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }
  describe "GET #index" do
    it "assigns @categories" do
      get :index
      expect(assigns(:categories)).to_not be_nil
    end

    it "assigns @pagy and @products" do
      get :index
      expect(assigns(:pagy)).to_not be_nil
      expect(assigns(:products)).to_not be_nil
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    context "with valid category" do
      it "assigns @category" do
        get :show, params: { id: category.slug }
        expect(assigns(:category)).to eq(category)
      end

      it "assigns @pagy and @products" do
        get :show, params: { id: category.slug }
        expect(assigns(:pagy)).to_not be_nil
        expect(assigns(:products)).to_not be_nil
      end

      it "renders the index template" do
        get :show, params: { id: category.slug }
        expect(response).to render_template(:index)
      end
    end

    context "with invalid category" do
      it "sets flash[:error] and redirects to root_path" do
        get :show, params: { id: 'invalid_slug' }
        expect(flash[:error]).to eq(I18n.t("alert.error_category"))
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
