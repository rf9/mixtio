class Consumable < ActiveRecord::Base

  belongs_to :consumable_type

  has_many :ancestors
  has_many :children, through: :ancestors, source: :family, class_name: 'Consumable', source_type: 'Child'
  has_many :parents, through: :ancestors, source: :family, class_name: 'Consumable', source_type: 'Parent'

  validates :name, presence: true
  validates :expiry_date, presence: true, expiry_date: true
  validates :lot_number, presence: true
  validates :consumable_type, existence: true

  before_create :set_batch_number
  after_create :generate_barcode

  def add_children(children)
    Array(children).each { |child| add_ancestor(child, self) }
    self
  end

  def add_parents(parents)
    Array(parents).each { |parent| add_ancestor(self, parent) }
    self
  end

  def save_or_mix(limit = 1)
    create_batch(limit).map! { |c| c.add_parents(Consumable.where(id: self.parent_ids)) }
  end

  def create_batch(limit)
    set_batch_number
    attributes = (1..limit).map { self.attributes }
    Consumable.create(attributes)
  end

  def self.get_next_batch_number
    count == 0 ? 1 : maximum(:batch_number) + 1
  end

  private

  def generate_barcode
    update_column(:barcode, "mx-#{self.name.gsub(' ','-').downcase}-#{self.id}")
  end

  def set_batch_number
    self.batch_number ||= Consumable.get_next_batch_number
  end

  def add_ancestor(child, parent)
    Ancestor.create(family_id: child.id, consumable_id: parent.id, family_type: "Child")
    Ancestor.create(family_id: parent.id, consumable_id: child.id, family_type: "Parent")
  end

end