class ConsumableCreator

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def run!
    cts = params["consumable_types"].map { |consumable_type| create_consumable_type(consumable_type) }

    params["suppliers"].each { |supplier| create_supplier(supplier) }

    params["lots"].each do |lot|
      lot = create_lot(lot)
    end

    Team.create!(name: "TEST TEAM")

    cts.each { |consumable_type| create_batch(consumable_type) }
  end

  private

  def create_consumable_type(consumable_type)
    ct = ConsumableType.create(name: consumable_type["name"], days_to_keep: consumable_type["days_to_keep"])
    if consumable_type["recipe_ingredients"]
      ct.recipe_ingredients = consumable_type["recipe_ingredients"].map { |ingredient| ConsumableType.find_by!(name: ingredient) }
      ct.save
    end
    ct
  end

  def create_supplier(supplier)
    Supplier.create!(name: supplier["name"])
  end

  def create_lot(lot)
    Lot.create(number: lot["number"],
               consumable_type: ConsumableType.find_by!(name: lot["consumable_type"]),
               kitchen: Supplier.find_by!(name: lot["supplier"]))
  end

  def create_batch(consumable_type)
    batch = consumable_type.ingredients.create!(
        expiry_date: Date.today.advance(days: consumable_type.days_to_keep).to_s(:uk),
        type: 'Batch',
        kitchen: Team.find_by!(name: "TEST TEAM"),
        volume: 1,
        unit: 'L',
    )
    consumable_type.recipe_ingredients.each do |recipe_ingredient|
      batch.ingredients << Lot.find_by(consumable_type: recipe_ingredient)
    end

    batch.consumables.create!(Array.new(rand(1..10), {}))
  end

end