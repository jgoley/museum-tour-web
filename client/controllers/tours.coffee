Template.tours.helpers
  'countStops' : () ->
    count = 0
    _.each this.stops, (stop) ->
      count++
      if stop.childStops
        count += stop.childStops.length
    count

