{ Template }  = require 'meteor/templating'
{ Tour }     = require '../../../api/tours/index'
{ TourStop } = require '../../../api/tour_stops/index'
{ _ }       = require 'meteor/underscore'

require '../views/tour.jade'
require '../../stops/controllers/stopSearch'

Template.tour.onCreated ->
  @tourID = @data.tourID
  @subscribe 'tourStops', @tourID
  @subscribe 'tourDetails', @tourID

  instance = @
  @autorun ->
    tour = Tour.findOne instance.tourID
    if tour
      family = ''
      if tour.tourType is 1 then family = ' (Family)'
      document.title = tour.mainTitle+': '+tour.subTitle+family

Template.tour.helpers
  tour: ->
    Tour.findOne Template.instance().tourID

  tourStops: ->
    TourStop.find
      $or: [{type: 'group'},{type: 'single'}]
      {sort: stopNumber: 1}

  stopParams: (stopID) ->
    tourID: tourID
    stopID: stopID

  isGroup: ->
    @type is "group"

  childStopCount: ->
    @childStops.length

  getTypes: ->
    children = TourStop.find
      _id:
        $in: @childStops
    _.sortBy _.uniq(_.pluck(children.fetch(), 'mediaType')), (type) -> type
