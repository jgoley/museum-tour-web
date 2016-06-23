require '../views/child_stops.jade'

Template.childStops.onCreated ->
  @addingChild = @data.addingStop

Template.childStops.helpers
  isAddingChild: ->
    Template.instance().addingChild.get()
  addingChild: ->
    Template.instance().addingChild

Template.childStops.events
  'click .add-child': (event, instance) ->
    adding = instance.addingChild
    adding.set not adding.get()
