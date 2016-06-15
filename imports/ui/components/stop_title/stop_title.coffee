{ showStop } = require '../../../helpers/edit'
parsley = require 'parsleyjs'

require './stop_title.jade'

Template.stopTitle.onCreated ->
  @data.activelyEditing = @activelyEditing
  @editingTitle = new ReactiveVar false

Template.stopTitle.onRendered ->
  $('.edit-title-form').parsley()

Template.stopTitle.helpers
  editingTitle: ->
    Template.instance().editingTitle.get()

Template.stopTitle.events
  'click .edit-title-btn' : (event, instance) ->
    editing = instance.editingTitle
    prop = "title-#{@stop._id}"
    if editing.get prop then value = 0 else value = 1
    editing.set prop, value

  'click .title': (event, instance)->
    editing = instance.activelyEditing
    editing.set not editing.get()
    console.log editing
    showStop instance, @stop

  'click .single-title': (event, instance)->
    showStop instance, @stop

  'click .cancel-edit-title': (event, instance) ->
    instance.editingTitle.set false

  'submit .edit-title-form': (event, instance) ->
    event.preventDefault()
    stop = @stop
    Meteor.call 'updateTitle', stop, event.target.title.value, (err, res) ->
      instance.editingTitle.set false
