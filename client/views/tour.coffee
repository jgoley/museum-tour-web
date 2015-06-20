Template.tour.helpers
  isGroup: () ->
    @type is "group"
  
  childStopsNumber : () ->
    @childStops.length
      
  getTypes : () ->
    types = _.chain(@childStops)
      .map((stop) -> stop.mediaType)
      .uniq()
      .value()
    console.log types
    types
