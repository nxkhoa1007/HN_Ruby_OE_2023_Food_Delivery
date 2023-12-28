RSpec.shared_examples "admin user access" do
  it "redirects to root path for non-admin users" do
    allow(controller).to receive(:current_user).and_return(user)
    subject
    expect(response).to redirect_to(root_path)
  end

  it "allows access for admin users" do
    allow(controller).to receive(:current_user).and_return(admin_user)
    subject
    expect(response).not_to redirect_to(root_path)
  end
end
