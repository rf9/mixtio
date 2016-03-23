FactoryGirl.define do
  factory :ingredient do
    sequence(:lot_number) { |n| "Lot #{n}" }

    sequence(:name) { |n| "Ingredient #{n}"}
    sequence(:supplier) { |n| "Supplier #{n}"}
    sequence(:product_code) { |n| "Product code #{n}"}

  end
end
