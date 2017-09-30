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
  Session.set 'searching', false
  @editTourDetails = new ReactiveVar false
  @uploading = new ReactiveVar false
  @addingStop = new ReactiveVar false
  @tourID = @data?.tourID
  @deleting = new ReactiveVar false
  @stopsLoaded = new ReactiveVar false
  @selectedParents = new ReactiveVar([])
  @foundChildren = new ReactiveVar([])
  @query = new ReactiveVar('')
  if @tourID
    @subscribe 'tourDetails', @tourID
    @subscribe 'tourStops', @tourID, () =>
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
    instance = Template.instance()
    textQuery = instance.query.get()
    query =
      type: $in: ['group', 'single']

    if textQuery
      query.type.$in.push('child')
      query = _.extend query,
        $or: [
          {title: new RegExp(textQuery, 'i')}
          {stopNumber: +textQuery}
        ]

    tourStops = TourStop.find(query, {sort: stopNumber: 1})

    if textQuery
      foundChildrenParents = []
      foundChildren = []
      singleStops = []
      tourStops.forEach (stop) ->
        if stop.type == 'child'
          foundChildren.push(stop._id)
          foundChildrenParents.push(stop.parent)
        else
          singleStops.push(stop._id)
      instance.selectedParents.set(foundChildrenParents)
      instance.foundChildren.set(foundChildren)
      TourStop.find
        $or: [
          {_id: $in: foundChildrenParents}
          {_id: $in: singleStops}
        ]
        {sort: stopNumber: 1}
    else
      tourStops

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

  selectedParents: ->
    Template.instance().selectedParents

  foundChildren: ->
    Template.instance().foundChildren

  highlightStop: ->
    instance = Template.instance()
    instance.stopID in instance.singleStops

Template.editTour.events
  'click .delete-tour': (event, instance) ->
    deleteTour = confirm("Delete tour? All stops will be deleted")
    tour = Tour.findOne(instance.tourID)
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
    show = instance.editTourDetails
    show.set(not show.get())

  'click .show-add-stop': (event, instance) ->
    instance.addingStop.set true
    setTimeout ->
      headerHeight = Meteor.settings.public.headerHeight
      $('html, body').animate
        scrollTop: $(".add-stop").offset().top - headerHeight
      , 800
    , 0

  'keyup .stop-search': _.debounce (event, instance) ->
    queryText = event.target.value
    if queryText == ''
      searching = false
      instance.selectedParents.set([])
      Session.set('editingAStop', false)
    else
      searching = true
    Session.set('searching', searching)
    instance.query.set(queryText)
  , 250
