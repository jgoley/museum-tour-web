{ ReactiveVar }      = require 'meteor/reactive-var'
{ showNotification } = require '../../../helpers/notifications'
{ Tour }             = require '../../../api/tours/index'
{ TourStop }         = require '../../../api/tour_stops/index'
{ go }               = require '../../../helpers/route_helpers'
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
  Session.set 'editingAStop', false
  @editTourDetails = new ReactiveVar false
  @uploading = new ReactiveVar false
  @addingStop = new ReactiveVar false
  @tourID = @data?.tourID
  if @tourID
    @subscribe 'tourDetails', @tourID
    @subscribe 'tourParentStops', @tourID

Template.editTour.helpers
  tour: ->
    Tour.findOne Template.instance().tourID

  stops: ->
    stops = TourStop.find {
      $or:
        [
          {type: 'group'},
          {type: 'single'}
        ]
      }, {sort: stopNumber: 1}
    stops

  sortableOptions : ->
    handle: '.handle'

  editTourDetails: ->
    Template.instance().editTourDetails.get()

  getEditing: ->
    Template.instance().editTourDetails

  isAddingStop: ->
    Template.instance().addingStop.get()

  addingStop: ->
    Template.instance().addingStop

Template.editTour.events
  'click .delete-tour': (event, instance) ->
    deleteTour = confirm("Delete tour? All stops will be deleted")
    instance.data.stops.forEach (stop) ->
      deleteFile(stop)
      TourStop.remove stop._id
    deleteFolder(@tour._id)
    Tour.remove @tour._id, () ->
      go '/admin'

  'click .show-tour-details': (event, instance) ->
    instance.editTourDetails.set true

  'click .show-add-stop': (event, instance) ->
    instance.addingStop.set true
    setTimeout (->
      $('html, body').animate({ scrollTop: $(".add-stop").offset().top - 55 }, 800)
      ), 0
