require "rails_helper"

RSpec.shared_context "shared admin controller" do
  let(:admin){create(:user, role: :admin)}

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end
end
