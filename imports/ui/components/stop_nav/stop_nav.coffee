import { TourStop } from '../../../api/tour_stops/index'
import { go } from  '../../../helpers/route_helpers'
import './stop_nav.jade'

jump = (event, instance, direction) ->
  stop = instance.stop
  event.preventDefault()
  stop = TourStop.findOne stopNumber: stop.stopNumber + direction
  instance.data.currentStop.set(stop._id)
  go 'stop', {stopID: stop._id, tourID: stop.tour}

Template.stopNav.onCreated ->
  @stop = @data.stop
  @subscribe 'adjacentStops', @stop._id, @stop.tour

Template.stopNav.helpers
  nextStop: ->
    TourStop.findOne stopNumber: Template.instance().stop.stopNumber + 1

  prevStop: ->
    TourStop.findOne stopNumber: Template.instance().stop.stopNumber - 1

Template.stopNav.events
  'click .next-stop': (event, instance) ->
    jump(event, instance, 1)

  'click .prev-stop': (event, instance) ->
    jump(event, instance, -1)
