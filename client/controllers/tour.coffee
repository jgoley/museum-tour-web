TourStops = () ->
  @Tap.Collections.TourStops

Template.tour.helpers
  showStops: ()->
    _.filter @stops.fetch(), (stop)->
      stop.type is 'group' or stop.type is 'single'

  isGroup: () ->
    @type is "group"

  getChildStopCount : () ->
    @childStops.length

  getTypes : () ->
    types = _.chain(@childStops)
      .map((stop) -> +TourStops().findOne(stop).mediaType)
      .uniq()
      .sortBy((stop)-> stop)
      .value()
    types
