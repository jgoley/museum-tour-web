{ showNotification } = require '../../../helpers/notifications'
{ go }               = require '../../../helpers/route_helpers'
{ Tours }            = require '../../../api/tours/index'
{ TourStops }        = require '../../../api/tour_stops/index'
{ parsley
  updateStop,
  showStop,
  getLastStopNum }   = require '../../../helpers/edit'

require '../../../ui/components/upload_progress/upload_progress.coffee'
require './stop_title'
require './edit_stop'
require '../views/edit_tour.jade'


Template.editTour.onCreated ->
  @editTourDetails = new ReactiveVar false
  @creatingStop = new ReactiveVar false
  @tourID = @data?.tourID
  if @tourID
    @subscribe 'tourDetails', @tourID
    @subscribe 'tourParentStops', @tourID

Template.editTour.helpers
  tour: ->
    Tours.findOne Template.instance().tourID

  stops: ->
    TourStops.find {}, {sort: stopNumber: 1}

  onlyOneStop: ->
    TourStops.findOne()

  editTourDetails: ->
    Template.instance().editTourDetails.get()

  getEditing: ->
    Template.instance().editTourDetails

Template.editTour.events
  'click .delete-tour': (e, template) ->
    deleteTour = confirm("Delete tour? All stops will be deleted")
    template.data.stops.forEach (stop) ->
      deleteFile(stop)
      TourStops.remove stop._id
    deleteFolder(@tour._id)
    Tours.remove @tour._id, () ->
      go '/admin'

  'click .show-tour-details': (e) ->
    Template.instance().editTourDetails.set(true)
