if Meteor.isClient

  Template.tour.onCreated ->
    @subscribe 'tourStops', @data.id
    @subscribe 'tourDetails', @data.id

    instance = @
    @autorun ->
      tour = Tours().findOne instance.data._id
      if tour
        if tour.tourType is 1 then family = ' (Family)'
        document.title = tour.mainTitle+': '+tour.subTitle+family

  Template.tour.helpers
    showStops: ->
      stops = TourStops().find().fetch()
      if stops
        _.filter stops, (stop)->
          stop.type is 'group' or stop.type is 'single'

    isGroup: ->
      @type is "group"

    getChildStopCount: ->
      @childStops.length

    getTypes: ->
      types = _.chain(@childStops)
        .map((stop) -> +TourStops().findOne(stop).mediaType)
        .uniq()
        .sortBy((stop)-> stop)
        .value()
      types
    stopNumbers: ->
      numbers = {}
      _.each @stops.fetch(), (stop) ->
        numbers[stop.stopNumber] =
          id: stop._id
          tour: stop.tour
      numbers


if Meteor.isServer
  Meteor.publish 'tourDetails', (tourID) ->
    Tours().find _id: tourID

  Meteor.publish 'tourStops', (tourID) ->
    TourStops().find tour: tourID
