class Consumable < ActiveRecord::Base

  belongs_to :consumable_type

  has_many :ancestors
  has_many :children, through: :ancestors, source: :family, class_name: 'Consumable', source_type: 'Child'
  has_many :parents, through: :ancestors, source: :family, class_name: 'Consumable', source_type: 'Parent'

  validates :name, presence: true
  validates :expiry_date, presence: true, expiry_date: true
  validates :lot_number, presence: true
  validates :consumable_type, existence: true

  after_create :generate_barcode

  def add_child(child)
    add_ancestor(child, self)
  end

  def add_parent(parent)
    add_ancestor(self, parent)
  end

  private

  def generate_barcode
    update_column(:barcode, "mx-#{self.name.gsub(' ','-').downcase}-#{self.id}")
  end

  def add_ancestor(child, parent)
    Ancestor.create(family_id: child.id, consumable_id: parent.id, family_type: "Child")
    Ancestor.create(family_id: parent.id, consumable_id: child.id, family_type: "Parent")
  end

end