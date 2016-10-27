{ ReactiveVar }        = require 'meteor/reactive-var'
{ showNotification }   = require '../../../helpers/notifications'
{ Tour }               = require '../../../api/tours/index'
{ TourStop }           = require '../../../api/tour_stops/index'
{ go }                 = require '../../../helpers/route_helpers'
{ parsley,
  setStopEditingState,
  getLastStopNum }     = require '../../../helpers/edit'
{ updateSortOrder }    = require '../../../helpers/sort'
Sort                   = require 'sortablejs'


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
  @deleting = new ReactiveVar false
  @stopsLoaded = new ReactiveVar false
  if @tourID
    @subscribe 'tourDetails', @tourID
    @subscribe 'tourParentStops', @tourID, () =>
      @stopsLoaded.set true

Template.editTour.onRendered ->
  instance = @
  @autorun ->
    tour = Tour.findOne @tourID
    if instance.stopsLoaded.get() and TourStop.findOne() and not instance.deleting.get()
      Meteor.setTimeout ->
        Sort.create stopList,
          handle: '.handle'
          onSort: (event) ->
            indices = [event.oldIndex, event.newIndex]
            updateSortOrder indices, instance.$(event.item).data('id')
      , 250

Template.editTour.helpers
  tour: ->
    Tour.findOne Template.instance().tourID

  stops: ->
    TourStop.find
      $and:
        [
          $or:
            [
              {type: 'group'},
              {type: 'single'}
            ]
        ]
      {sort: stopNumber: 1}

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
    tour = Tour.findOne @tourId
    if deleteTour
      deleting = instance.deleting
      deleting.set true
      tour.delete()
        .then ->
          deleting.set false
          go '/tours/edit'
        .catch (error) ->
          deleting.set false
          console.log error
          showNotification error

  'click .show-tour-details': (event, instance) ->
    instance.editTourDetails.set true

  'click .show-add-stop': (event, instance) ->
    instance.addingStop.set true
    setTimeout (->
      $('html, body').animate({ scrollTop: $(".add-stop").offset().top - 55 }, 800)
      ), 0
