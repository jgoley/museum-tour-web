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
    enteredStop = e.target.value
    unless enteredStop
      instance.buttonState.set true
      return
    requestingHelp = +enteredStop == 0 or enteredStop.match(/help/i)
    if TourStop.findOne(stopNumber: +enteredStop) or requestingHelp
      instance.buttonState.set false
    else
      instance.buttonState.set true

  'submit .goto-stop': (e, instance) ->
    e.preventDefault()
    number = e.target.stopNumber.value
    if +number == 0 or number.match(/help/i)
      go('help')
      return
    stop = TourStop.findOne stopNumber: +number
    analytics.track 'Stop Search',
      eventName: instance.data.location or 'Stop Search'
      stopNumber: number

    go 'stop', {'tourID': stop.tour, 'stopID': stop._id}

Template.stopSearch.helpers
  buttonState: ->
    Template.instance().buttonState.get()
