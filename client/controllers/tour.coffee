TourStops = ->
  @Tap.Collections.TourStops

Template.tour.onCreated ->
  tour = Template.instance().data.tour
  if tour.tourType is 1 then family = ' (Family)'
  document.title = tour.mainTitle+': '+tour.subTitle+family

Template.tour.helpers
  showStops: ->
    _.filter @stops.fetch(), (stop)->
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
