class Ingredient < ActiveRecord::Base
  belongs_to :consumable_type
  belongs_to :kitchen

  has_many :mixtures

  validates :name, :supplier, :product_code, presence: true
end
