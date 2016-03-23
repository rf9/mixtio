class Mixtio.Views.Lot extends Backbone.View

  tagName: 'tr'

  events:
    'click a[data-behavior~=remove_row]': 'close'

  initialize: (options) ->
    @ingredientTypes = options.ingredientTypes

    @on("render", () => @setSubviews())

  setSubviews: () ->
    @ingredientTypeSelect = @$el.find('select[name*="ingredient_id"]')

  render: () ->
    @$el.html(JST['batches/ingredient'](
      lot: @model
      ingredientTypes: @ingredientTypes
    ))

    @trigger("render")
    this

  close: (e) ->
    e.preventDefault()
    @$el.fadeOut(400, () =>
      @$el.remove()
      @collection.remove(@model)
    )