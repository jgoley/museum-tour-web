import { ReactiveVar } from 'meteor/reactive-var'
import { showNotification } from '../../../helpers/notifications'
import { Tour } from '../../../api/tours/index'
import { TourStop } from '../../../api/tour_stops/index'
import { go } from '../../../helpers/route_helpers'
import { parsley,
         setStopEditingState,
         getLastStopNum } from '../../../helpers/edit'
import { updateSortOrder } from '../../../helpers/sort'
import Sort from 'sortablejs'


import '../../../ui/components/upload_progress/upload_progress.coffee'
import './stop_title'
import './edit_stop'
import './child_stops'
import '../views/edit_tour.jade'

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
  @autorun =>
    tour = Tour.findOne @tourID
    if @stopsLoaded.get() and TourStop.findOne() and not @deleting.get()
      Meteor.setTimeout =>
        Sort.create stopList,
          handle: '.handle'
          onSort: (event) =>
            indices = [event.oldIndex, event.newIndex]
            updateSortOrder indices, TourStop.findOne(@$(event.item).data('stopid'))
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
