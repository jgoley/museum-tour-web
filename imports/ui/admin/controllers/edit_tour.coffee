{ ReactiveVar } = require 'meteor/reactive-var'
{ showNotification } = require '../../../helpers/notifications'
{ go }               = require '../../../helpers/route_helpers'
{ Tour }             = require '../../../api/tours/index'
{ TourStop }         = require '../../../api/tour_stops/index'
{ parsley
  updateStop,
  setStopEditingState,
  getLastStopNum }   = require '../../../helpers/edit'

require '../../../ui/components/upload_progress/upload_progress.coffee'
require './stop_title'
require './edit_stop'
require './child_stops'
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
    Tour.findOne Template.instance().tourID

  stops: ->
    TourStop.find {
      $or:
        [
          {type: 'group'},
          {type: 'single'}
        ]
      }, {sort: stopNumber: 1}

  onlyOneStop: ->
    TourStop.findOne()

  editTourDetails: ->
    Template.instance().editTourDetails.get()

  getEditing: ->
    Template.instance().editTourDetails

  showAddStop: ->
    Session.get('add-stop')

Template.editTour.events
  'click .delete-tour': (e, template) ->
    deleteTour = confirm("Delete tour? All stops will be deleted")
    template.data.stops.forEach (stop) ->
      deleteFile(stop)
      TourStop.remove stop._id
    deleteFolder(@tour._id)
    Tour.remove @tour._id, () ->
      go '/admin'

  'click .show-tour-details': (e) ->
    Template.instance().editTourDetails.set(true)
