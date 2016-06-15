{Template}    = require 'meteor/templating'
{ReactiveVar} = require 'meteor/reactive-var'
{TourStops}   = require '../../../api/tour_stops/index'
{go}          = require '../../../helpers/route_helpers'

require '../views/stopSearch.jade'

Template.stopSearch.onCreated ->
  @buttonState = new ReactiveVar(true)

Template.stopSearch.events
  'input .stopNumber': _.throttle (e, instance)->
    if TourStops.findOne(stopNumber: +e.target.value)
      instance.buttonState.set(false)
    else
      instance.buttonState.set(true)

  'submit .goto-stop': (e, instance) ->
    e.preventDefault()
    stop = TourStops.findOne stopNumber: +e.target.stopNumber.value
    go 'stop', {'tourID': stop.tour, 'stopID': stop._id}

Template.stopSearch.helpers
  buttonState: ->
    Template.instance().buttonState.get()
