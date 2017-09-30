import { ReactiveVar } from 'meteor/reactive-var'
import { setStopEditingState,
         stopEditing,
         parsley } from '../../../helpers/edit'
import { updateSortOrder } from '../../../helpers/sort'

import '../views/stop_title.jade'

openStop = (instance, event) ->
  editing = instance.editingStop
  editing.set not editing.get()
  headerHeight = Meteor.settings.public.headerHeight
  $('html, body').animate
    scrollTop: instance.$(event.target).parent().offset().top - headerHeight - 3
  , 500

Template.stopTitle.onCreated ->
  @editingStop = @data.editingStop
  @editingTitle = new ReactiveVar false

Template.stopTitle.onRendered ->
  @autorun =>
    if @editingTitle.get()
      Meteor.defer ->
        parsley '.edit-title-form'

Template.stopTitle.helpers
  editingTitle: ->
    Template.instance().editingTitle.get()

  editingStop: ->
    Template.instance().editingStop.get()

  editingAStop: ->
    if Session.get('editingAStop') and not Template.instance().editingStop.get() and not @stop.isChild()
      true

  stopOrder: ->
    stop = Template.instance().data.stop
    if stop.order and not _.isNaN(stop.order)
      stop.order
    else
      stop.stopNumber

Template.stopTitle.events
  'click .edit-title-btn' : (event, instance) ->
    event.stopPropagation()
    editing = instance.editingTitle
    editing.set not editing.get()

  'click .edit-title-form': (event, instance) ->
    event.stopPropagation()

  'click .cancel-edit-title': (event, instance) ->
    instance.editingTitle.set false

  'submit .edit-title-form': (event, instance) ->
    event.preventDefault()
    stop = @stop
    stop.title = event.target.title.value
    stop.save (error) ->
      unless error
        instance.editingTitle.set false

  'click .group-title, click .single-title': (event, instance) ->
    editing = instance.editingStop
    openStop instance, event
    if Session.get('searching')
      Session.set('editingAStop', false)
    else
      Session.set 'editingAStop', not Session.get 'editingAStop'
    $(document).keyup (event) ->
      if event.which is 27
        stopEditing editing
        $(document).off 'keyup'
    $(document).on 'click', (event) ->
      if event.target.className.match /edit\-parent\-stops/
        stopEditing editing
        $(document).off 'click'

  'click .child-title': (event, instance)->
    openStop instance, event

  'click .delete': (event, instance) ->
    event.stopPropagation()
    event.preventDefault()
    deleting = instance.data.deleting
    deleting.set true
    stop = @stop
    stop.delete()
      .then ->
        updateSortOrder null, stop, true
        stopEditing instance.editingStop
        deleting.set false
