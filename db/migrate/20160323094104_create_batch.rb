class CreateBatch < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.belongs_to :consumable_type, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.string :number
      t.date :expiry_date
      t.decimal :volume, precision: 10, scale: 3
      t.integer :unit
      t.timestamps null: false
    end

    change_table :ingredients do |t|
      t.remove :type, :expiry_date, :volume, :unit, :consumable_type_id, :kitchen_id

      t.rename :number, :lot_number
      t.string :name
      t.string :supplier
      t.string :product_code
    end

    remove_column :kitchens, :type
    rename_table :kitchens, :teams
  end
end
