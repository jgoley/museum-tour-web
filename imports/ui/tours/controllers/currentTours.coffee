{ Tour }     = require '../../../api/tours/index'
{ TourStop } = require '../../../api/tour_stops/index'

require '../views/currentTours.jade'
require '../../components/thumbnail/thumbnail.coffee'
require '../../components/stop_search/stop_search.coffee'

Template.currentTours.onCreated ->
  @subscribe 'currentTours'
  @subscribe 'currentTourStops'
  document.title = 'Current Tours'

Template.currentTours.helpers
  tours: ->
    Tour.find()

  stops: ->
    TourStop.find()
