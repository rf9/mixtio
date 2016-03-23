class Mixtio.Views.Lots extends Backbone.View

  initialize: (options) ->
    @ingredientTypes = options.ingredientTypes
    @kitchens = options.kitchens

    @collection.on('reset', () => @render())
    @collection.on('add', () => @add())

  render: () ->
    # Remove all the rows except the header
    @$el.find("tr:gt(0)").remove()

    @collection.each (lot) =>
      ingredientView = new Mixtio.Views.Lot(
        collection: @collection
        model: lot
        ingredientTypes: @ingredientTypes
        kitchens: @kitchens
      )

      @$el.append(ingredientView.render().el)

    this

  add: () ->
    ingredientView = new Mixtio.Views.Lot(
      collection: @collection
      model: @collection.models[@collection.length - 1]
      ingredientTypes: @ingredientTypes
      kitchens: @kitchens
    )

    @$el.append(ingredientView.render().el)

  update: (lots = new Mixtio.Collections.Lots()) ->
    @collection.reset()

    lots.each (lot) =>
      @collection.add(lot)