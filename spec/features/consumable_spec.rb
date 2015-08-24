require "rails_helper"

RSpec.describe "Consumables", type: feature do

  let! (:consumable_types) { create_list(:consumable_type, 4) }

  it "Displays a list of consumables to the user" do
    consumable = create(:consumable)
    consumable_2 = create(:consumable)

    visit consumables_path

    expect(page).to have_content(consumable.name)
    expect(page).to have_content(consumable.name)
  end

  it "Allows a user to create a new consumable" do
    consumable = build(:consumable)

    visit consumables_path
    click_link "Add new consumable"
    expect{
      fill_in "Name", with: consumable.name
      fill_in "Expiry date", with: consumable.expiry_date
      fill_in "Lot number", with: consumable.lot_number
      fill_in "Arrival date", with: consumable.arrival_date
      fill_in "Supplier", with: consumable.supplier
      select consumable_types.first.name, from: 'Consumable type'
      click_button "Create Consumable"
    }.to change(Consumable, :count).by(1)
    expect(page).to have_content("Consumable successfully created")
  end

  it "Reports an error if a user adds a consumable with invalid attributes" do

    consumable = build(:consumable, name: nil)

    visit new_consumable_path
    expect{
      fill_in "Name", with: consumable.name
      fill_in "Expiry date", with: consumable.expiry_date
      fill_in "Lot number", with: consumable.lot_number
      fill_in "Arrival date", with: consumable.arrival_date
      fill_in "Supplier", with: consumable.supplier
      select consumable_types.first.name, from: 'Consumable type'
      click_button "Create Consumable"
    }.to_not change(Consumable, :count)

    expect(page).to have_content("error prohibited this record from being saved")
  end

  it "Allows a user to edit a consumable" do
    consumable = create(:consumable)
    new_consumable = build(:consumable)

    visit consumables_path
    expect{
      find(:data_id, consumable.id).click_link "Edit"
      fill_in "Name", with: new_consumable.name
      click_button "Update Consumable"
    }.to change{ consumable.reload.name }.to(new_consumable.name)
    expect(page).to have_content("Consumable successfully updated")
  end

end