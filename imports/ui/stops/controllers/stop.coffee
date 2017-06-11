import { ReactiveVar } from 'meteor/reactive-var'
import { TourStop } from '../../../api/tour_stops/index'
import { go } from  '../../../helpers/route_helpers'
import { analytics } from 'meteor/okgrow:analytics'

import '../views/stop.jade'

Template.stop.onCreated ->
  @stopID = new ReactiveVar @data.stopID

Template.stop.onRendered ->
  @stopID.set @data.stopID
  instance = @
  @autorun ->
    stopID = instance.stopID.get()
    instance.subscribe 'stop', stopID
    instance.subscribe 'childStops', stopID
    instance.subscribe 'adjacentStops', stopID, instance.tourID

  @autorun ->
    instance.stop = TourStop.findOne instance.stopID.get()
    if instance.stop
      title = instance.stop.title
      document.title = title
      analytics.page(title)

  @autorun ->
    stopID = FlowRouter.getParam 'stopID'
    instance.stopID.set stopID

Template.stop.helpers
  stop: ->
    TourStop.findOne Template.instance().stopID.get()

  nextStop: ->
    TourStop.findOne stopNumber: Template.instance().stop?.stopNumber + 1

  prevStop: ->
    TourStop.findOne stopNumber: Template.instance().stop?.stopNumber - 1

  isNull: (value) ->
    value and value.match(/NULL/gi)

jump = (event, instance, direction) ->
  event.preventDefault()
  stop = TourStop.findOne stopNumber: instance.stop.stopNumber + direction
  instance.stopID.set(stop._id)
  go 'stop', {stopID: stop._id, tourID: stop.tour}

Template.stop.events
  'click .next-stop': (event, instance) ->
    jump event, instance, 1

  'click .prev-stop': (event, instance) ->
    jump event, instance, -1
