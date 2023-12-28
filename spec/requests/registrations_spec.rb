require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "PUT #update_info" do
    context "with valid params" do
      let(:valid_params) {  { user: attributes_for(:user, name: "Lam") } }
      before do
        put :update_info, params: valid_params
        user.reload
      end
      it "updates user information" do
        expect(user.name).to eq("Lam")
      end

      it "redirects back with flash success" do
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq(I18n.t("alert.update_success"))
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { user: attributes_for(:user, name: "") } }
      before do
        put :update_info, params: invalid_params
      end
      it "does not update user information" do
        user.reload
        expect(user.name).not_to eq("")
      end

      it "renders the edit template with error" do
        expect(response).to render_template(:edit)
      end
    end
  end
  describe "GET #change" do
    it "renders the edit template" do
      get :change, params: { id: user }
      expect(response).to render_template(:change)
    end
  end
  describe "PATCH #update_password" do
    context "with valid params" do
      let(:valid_params) { { current_password: user.password, password: "new_password", password_confirmation: "new_password" } }

      it "updates user password and signs out" do
        patch :update_password, params: { user: valid_params }
        expect(user.valid_password?(user.password)).to be_truthy
        user.reload
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t("alert.update_success"))
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { current_password: "current_password", password: "short", password_confirmation: "short" } }
      before do
        expect(user.valid_password?("short")).to be_falsey
        put :update_password, params: { user: invalid_params }
      end
      it "does not update user password" do
        user.reload
        expect(user.valid_password?("short")).to be_falsey
      end
      it "render the change password template" do
        expect(response).to render_template(:change)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "#after_inactive_sign_up_path_for" do
    it "redirects to the edit account path" do
      expect(controller.send(:after_inactive_sign_up_path_for, user)).to eq(new_user_registration_path(user))
    end
  end

end
