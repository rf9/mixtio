class ConsumableForm
  include ActiveModel::Model

  validate :check_consumable
  validate :check_limit

  attr_reader :consumable
  attr_accessor :limit

  ATTRIBUTES = [:name, :expiry_date, :lot_number, :arrival_date, :supplier, :consumable_type_id, :parent_ids]
  delegate *ATTRIBUTES, :id, to: :consumable

  def self.model_name
    ActiveModel::Name.new(Consumable, nil, nil)
  end

  def initialize(consumable = Consumable.new)
    @consumable = consumable
  end

  def submit(params)
    @limit = set_limit(params)
    consumable.attributes = params[:consumable].slice(*ATTRIBUTES).permit!
    consumable.parent_ids = get_parent_ids(params[:consumable].slice(:parent_ids))
    if valid?
      if consumable.new_record?
        @consumables = consumable.save_or_mix(limit)
        true
      else
        consumable.save
      end
    else
      false
    end
  end

  def consumables
    @consumables ||= []
  end

  def persisted?
    consumable.id?
  end

  private

  def set_limit(params)
    limit = params[:consumable].slice(:limit)
    limit[:limit].present? ? limit[:limit].to_i : 1
  end

  def check_consumable
    unless consumable.valid?
      consumable.errors.each do |key, value|
        errors.add key, value
      end
    end
  end

  def check_limit
    if limit < 1
      errors.add :limit, 'should be greater than 0'
    end
  end

  def get_parent_ids(params)
    return unless params[:parent_ids]
    return params[:parent_ids].split(",")
  end
end