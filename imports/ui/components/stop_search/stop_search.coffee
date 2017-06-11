import { ReactiveVar } from 'meteor/reactive-var'
import { TourStop } from '../../../api/tour_stops/index'
import { go } from '../../../helpers/route_helpers'
import { analytics } from 'meteor/okgrow:analytics'

import './stop_search.jade'

Template.stopSearch.onCreated ->
  @buttonState = new ReactiveVar(true)
  @stops = @data.stops

Template.stopSearch.events
  'input .stopNumber': (e, instance) ->
    if TourStop.findOne(stopNumber: +e.target.value)
      instance.buttonState.set false
    else
      instance.buttonState.set true

  'submit .goto-stop': (e, instance) ->
    e.preventDefault()
    number = e.target.stopNumber.value
    stop = TourStop.findOne stopNumber: +number
    analytics.track 'Stop Search',
      eventName: instance.data.location or 'Stop Search'
      stopNumber: number

    go 'stop', {'tourID': stop.tour, 'stopID': stop._id}

Template.stopSearch.helpers
  buttonState: ->
    Template.instance().buttonState.get()
