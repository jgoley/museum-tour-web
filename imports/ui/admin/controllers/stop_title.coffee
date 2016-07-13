{ ReactiveVar }         = require 'meteor/reactive-var'
{ setStopEditingState,
  stopEditing,
  parsley }             = require '../../../helpers/edit'

require '../views/stop_title.jade'

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

  draggable: ->
    @stop.isGroup() or @stop.isSingle()

Template.stopTitle.events
  'click .edit-title-btn' : (event, instance) ->
    editing = instance.editingTitle
    prop = "title-#{@stop._id}"
    if editing.get prop then value = 0 else value = 1
    editing.set prop, value

  'click .group-title, click .single-title': (event, instance)->
    Session.set 'editingAStop', not Session.get 'editingAStop'
    editing = instance.editingStop
    $(document).keyup (event) ->
      if event.which is 27
        stopEditing editing
        $(document).off 'keyup'
    $(document).on 'click', (event) ->
      if event.target.className.match /edit\-parent\-stops/
        stopEditing editing
        $(document).off 'click'

  'click .title': (event, instance)->
    editing = instance.editingStop
    editing.set not editing.get()
    $('html, body').animate scrollTop: instance.$(event.target).parent().offset().top, 500

  'click .cancel-edit-title': (event, instance) ->
    instance.editingTitle.set false

  'submit .edit-title-form': (event, instance) ->
    event.preventDefault()
    stop = @stop
    Meteor.call 'updateTitle', stop, event.target.title.value, (err, res) ->
      instance.editingTitle.set false
