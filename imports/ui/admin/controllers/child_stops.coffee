import '../views/child_stops.jade'
import { TourStop } from '../../../api/tour_stops/index'
import { showNotification } from '../../../helpers/notifications'
import { updateSortOrder } from '../../../helpers/sort'
import Sort from 'sortablejs'

Template.childStops.onCreated ->
  @addingChild = @data.addingStop

Template.childStops.onRendered  ->
  setTimeout =>
    Sort.create childStopList,
      handle: '.handle'
      onSort: (event) =>
        indices = [event.oldIndex, event.newIndex]
        updateSortOrder indices, TourStop.findOne(@$(event.item).data('stopid'))
  , 250

Template.childStops.helpers
  isAddingChild: ->
    Template.instance().addingChild.get()

Template.childStops.events
  'click .add-child': (event, instance) ->
    adding = instance.addingChild
    adding.set not adding.get()
