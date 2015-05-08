require "rails_helper"

RSpec.describe Permissions::GuestPermission, type: :model do

  let(:permissions) { Permissions.permission_for(build(:guest))}

  it "should not allow anything" do
    expect(permissions).to_not allow(:any, :thing)
  end

  it "should not allow a specific action" do
    expect(permissions).to_not allow(:user, :create)
  end


end