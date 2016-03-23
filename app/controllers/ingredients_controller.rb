class IngredientsController < ApplicationController

  before_action :ingredients, only: [:index]
  before_action :authenticate!, except: [:index]

  def index
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      redirect_to ingredients_path, notice: "Ingredient successfully created"
    else
      render :new
    end
  end

  def edit
    @ingredient = current_resource
  end

  def update
    @ingredient = current_resource
    if @ingredient.update_attributes(ingredient_params)
      redirect_to ingredients_path, notice: "Ingredient successfully updated"
    else
      render :edit
    end
  end

private

  def ingredients
    @ingredients ||= Ingredient.page(params[:page])
  end

  def current_resource
    Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :supplier, :product_code)
  end

  helper_method :ingredients
end
