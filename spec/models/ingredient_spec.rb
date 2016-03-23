require 'rails_helper'

RSpec.describe Ingredient, type: :model do

  it "is not valid without a Consumable Type" do
    expect(build(:ingredient, consumable_type: nil)).to_not be_valid
  end

  it "is not valid without a Kitchen" do
    expect(build(:ingredient, kitchen: nil)).to_not be_valid
  end

  it 'is valid with a number' do
    expect(build(:ingredient, number: 123)).to be_valid
  end

  it 'is valid without a number' do
    expect(build(:ingredient, number: nil)).to be_valid
  end

end
