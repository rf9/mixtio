require 'rails_helper'

RSpec.describe Team, type: :model do
  it "should not be valid without a name" do
    expect(build(:team, name: nil)).to_not be_valid
  end

  it "should not allow duplicate names" do
    team = create(:team)
    expect(build(:team, name: team.name)).to_not be_valid
  end
end
