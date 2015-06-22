Template.tour.helpers
  showStops: ()->
    _.filter @stops.fetch(), (stop)->
      stop.type is 'group' or stop.type is 'single'

  isGroup: () ->
    @type is "group"

  childStopsNumber : () ->
    @childStops.length

  getTypes : () ->
    types = _.chain(@childStops)
      .map((stop) -> stop.mediaType)
      .uniq()
      .value()
    types
