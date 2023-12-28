require "rails_helper"
RSpec.describe UserInfosController, type: :controller do
  let(:user) { create(:user) }
  let(:user_info) { create(:user_info, user: user) }
  let(:valid_params) { { user_info: attributes_for(:user_info) } }
  let(:invalid_params) { { user_info: { name: "", phoneNum: "", address: "" } } }
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "load user infos list" do
    it "assigns @user_infos with default_info_list" do
      get :index
      expect(assigns(:user_infos)).to eq(user.user_infos.default_info_list)
    end

    it "redirects to root_path if @user_infos is nil" do
      allow(user).to receive_message_chain(:user_infos, :default_info_list).and_return(nil)
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe "load user info" do
    it "assigns @user_info with the correct user_info" do
      get :edit, params: { id: user_info.id }
      expect(assigns(:user_info)).to eq(user_info)
    end

    it "redirects to root_path if @user_info is nil" do
      allow(UserInfo).to receive(:find_by).and_return(nil)
      get :edit, params: { id: -1 }
      expect(response).to redirect_to(root_path)
    end
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
      it "creates a new user_info" do
        expect {
          post :create, params: valid_params
        }.to change(UserInfo, :count).by(1)
      end

      it "calls handle_success_response" do
        post :create, params: valid_params
        expect(response).to redirect_to(address_user_path)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { user_info: attributes_for(:user_info, name: nil) } }

      it "does not create a new user_info" do
        expect {
          post :create, params: invalid_params
        }.not_to change(UserInfo, :count)
      end

      it "calls handle_error_response" do
        post :create, params: invalid_params
        expect(response).to be_redirect
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: user_info }
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #set_default" do
    context "when setting as default is successful" do
      it "calls handle_success_response" do
        expect(controller).to receive(:handle_success_response)
        put :set_default, params: { id: user_info }
      end
    end
  end

  describe "PUT #update" do
    context "when params is valid" do
      before do
        @user_info = user_info
        put :update, params: { id: @user_info.id, user_info: valid_params }
        @user_info.reload
      end

      it "calls handle_success_response" do
        expect(controller).to receive(:handle_success_response)
        put :update, params: { id: @user_info.id, user_info: valid_params }
      end
    end

    context "when params is invalid" do
      before do
        @user_info = user_info
        put :update, params: { id: @user_info.id, user_info: invalid_params }
        @user_info.reload
      end

      it "calls handle_error_response" do
        expect(response).to redirect_to(address_user_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when destroy is successful" do
      it "redirects to the address page" do
        delete :destroy, params: { id: user_info }
        expect(response).to redirect_to(address_user_path)
      end
    end
    context "when destroy fails" do
      it "redirects to the address page" do
        delete :destroy, params: { id: user_info.id }
        expect(response).to redirect_to(address_user_path)
      end

      it "sets the flash error message if destroy fails" do
        allow_any_instance_of(UserInfo).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: user_info.id }
        expect(flash[:error]).to eq(I18n.t("alert.error"))
      end
    end
  end
end
