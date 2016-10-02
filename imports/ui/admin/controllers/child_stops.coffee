require '../views/child_stops.jade'
{ TourStop }         = require '../../../api/tour_stops/index'
{ showNotification } = require '../../../helpers/notifications'
{ updateSortOrder }  = require '../../../helpers/sort'
Sort                 = require 'sortablejs'

Template.childStops.onCreated ->
  @addingChild = @data.addingStop
  @subscribe 'childStops', @data.stop._id

Template.childStops.onRendered  ->
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

  childStops: ->
    TourStop.find {parent: @_id}, {sort: {order:1}}

Template.childStops.events
  'click .add-child': (event, instance) ->
    adding = instance.addingChild
    adding.set not adding.get()
  'submit .update-stop-number': (event, instance) ->
    event.preventDefault()
    @stop.stopNumber = +event.target.stopNumber.value
    @stop.save -> showNotification()
