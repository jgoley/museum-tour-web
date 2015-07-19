Template.currentTours.helpers
  stopNumbers: ->
    obj = {}
    _.each @stopNumbers.fetch(), (stop) ->
      obj[stop.stopNumber] = {id: stop._id, tour: stop.tour}
    obj
  type: ->
    if @tourType is 0
      'adult'
    else if @tourType is 1
      'family'
