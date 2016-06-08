{ Template }  = require 'meteor/templating'
{ Tours }     = require '../../../api/tours/index'
{ TourStops } = require '../../../api/tour_stops/index'

require '../views/currentTours.jade'
require '../../components/thumbnail/thumbnail'
require '../../stops/controllers/stopSearch'

Template.currentTours.onCreated ->
  @subscribe 'currentTours'
  @subscribe 'currentTourStops'
  document.title = 'Current Tours'

Template.currentTours.helpers
  tours: ->
    Tours.find()
  stopNumbers: ->
    TourStops.find()
