class Mixtio.Models.ConsumableType extends Backbone.Model

  initialize: (attributes) ->
    attributes.latest_lots ||= []
    @set('latest_lots', new Mixtio.Collections.Lots(attributes.latest_lots))

  favourite: () ->
    @_favourites_controller('create')

  unfavourite: () ->
    @_favourites_controller('delete')

  _favourites_controller: (method) =>
    url = '/favourites/' + @id
    Backbone.sync(method, @, url: url)
