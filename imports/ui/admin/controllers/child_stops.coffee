require '../views/child_stops.jade'
{ showNotification } = require '../../../helpers/notifications'
{ updateSortOrder }  = require '../../../helpers/edit'
Sort                 = require 'sortablejs'

Template.childStops.onCreated ->
  @addingChild = @data.addingStop

Template.childStops.onCreated ->
  instance = @
  Meteor.setTimeout ->
    Sort.create childStopList,
      handle: '.handle'
      onSort: (event) ->
        updateSortOrder event, instance, 'order', 0, instance.data.stop._id
  , 250

Template.childStops.helpers
  isAddingChild: ->
    Template.instance().addingChild.get()
  addingChild: ->
    Template.instance().addingChild

Template.childStops.events
  'click .add-child': (event, instance) ->
    adding = instance.addingChild
    adding.set not adding.get()
  'submit .update-stop-number': (event, instance) ->
    event.preventDefault()
    @stop.stopNumber = +event.target.stopNumber.value
    @stop.save -> showNotification()
