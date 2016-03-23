$ ->
  for item in $("#batch-ingredients-table")

    # Create the Collections
    userFavouritesCollection = new Mixtio.Collections.UserFavourites(Mixtio.Bootstrap.UserFavourites)
    consumableTypesCollection = new Mixtio.Collections.ConsumableTypes(Mixtio.Bootstrap.ConsumableTypes)
    lotsCollection = new Mixtio.Collections.Lots()

    # Create the Views
    consumableTypeView = new Mixtio.Views.ConsumableTypes(
      el: $('#batch_form_consumable_type_id')
      collection: consumableTypesCollection
      favourites: userFavouritesCollection
    )

    favouritesStarView = new Mixtio.Views.FavouritesStar(el: $('i.fa-star'))

    lotsView = new Mixtio.Views.Lots(
      el: item,
      collection: lotsCollection
      ingredientTypes: Mixtio.Bootstrap.IngredientTypes
    )

    scanConsumableView = new Mixtio.Views.ScanConsumable(
      el: $('#consumable-barcode')
      collection: lotsCollection
    )

    addIngredientView = new Mixtio.Views.AddLot(
      el: $('#add_ingredient_button')
      collection: lotsCollection
    )

    expiryDateView = new Mixtio.Views.ExpiryDate(el: $('#batch_form_expiry_date'))

    # Wire everything together

    ## When a favourite is added/removed to/from the User Favourites, update the Consumable Types view
    consumableTypeView.listenTo(userFavouritesCollection, 'add remove', consumableTypeView.render)

    ## When the Consumable Type is changed, update the Favourites Star, the Expiry Date, and set
    ## the Ingredients
    consumableTypeView.on("change:selected", (model, options) ->
      favouritesStarView.update(model, options)
      expiryDateView.update(model)

      console.log model?.get('latest_lots')

      lotsView.update(model?.get('latest_lots'))
    )

    ## When the user favourites/unfavourites a Consumable Type, add/remove it to/from the collection
    userFavouritesCollection.listenTo(favouritesStarView, 'favourite', userFavouritesCollection.add)
    userFavouritesCollection.listenTo(favouritesStarView, 'unfavourite', userFavouritesCollection.remove)

    # And finally render
    consumableTypeView.render()

  $('[data-toggle="tooltip"]').tooltip()