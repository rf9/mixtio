class Mixtio.Views.AddLot extends Backbone.View

  events:
    "click": "click"

  click: (e) ->
    e.preventDefault()
    @collection.add(new Mixtio.Models.Lot())