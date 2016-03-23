class Batch < ActiveRecord::Base

  include Auditable
  include HasVolume

  belongs_to :user
  belongs_to :consumable_type

  has_many :consumables
  has_many :lots
  has_many :ingredients, through: :lots

  validates :consumable_type, :user, presence: true
  validates :expiry_date, presence: true, expiry_date: true
  validates :volume, presence: true, numericality: {greater_than: 0}
  validates :unit, presence: true

  after_create :generate_batch_number

  scope :order_by_created_at, -> { order('created_at desc') }

  private

  def generate_batch_number
    update_column(:number, "#{self.user.team.name.upcase.gsub(/\s/, '')}-#{self.id}")
  end
end
