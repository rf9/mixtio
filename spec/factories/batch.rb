FactoryGirl.define do
  factory :batch do
    kitchen
    consumable_type
    sequence(:number) { |n| "Ingredient #{n}" }

    expiry_date { 33.days.from_now }
    volume { 1 }
    unit { 'L' }

    factory :batch_with_consumables, parent: :batch do
      consumables { build_list :consumable, 3 }
    end

  end
end
