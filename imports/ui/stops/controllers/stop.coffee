import { ReactiveVar } from 'meteor/reactive-var'
import { TourStop } from '../../../api/tour_stops/index'
import { go } from  '../../../helpers/route_helpers'
import { analytics } from 'meteor/okgrow:analytics'

import '../views/stop.jade'
import '../../components/stop_nav/stop_nav.coffee'

Template.stop.onCreated ->
  @stopID = new ReactiveVar @data.stopID

Template.stop.onRendered ->
  @stopID.set @data.stopID

  # Subscribe to collections when stopID changes
  @autorun =>
    stopID = @stopID.get()
    @subscribe 'stop', stopID
    @subscribe 'childStops', stopID

  # When stopId param changes update stopID
  @autorun =>
    stopID = FlowRouter.getParam('stopID')
    @stopID.set(stopID)

  # Update page title when stop changes
  @autorun =>
    @stop = TourStop.findOne(@stopID.get())
    if @stop
      title = @stop.title
      document.title = title
      analytics.page(title)

Template.stop.helpers
  stop: ->
    TourStop.findOne Template.instance().stopID.get()

  stopID: ->
    Template.instance().stopID
