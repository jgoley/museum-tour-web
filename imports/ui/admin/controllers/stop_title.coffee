{ ReactiveVar } = require 'meteor/reactive-var'
{ setStopEditingState } = require '../../../helpers/edit'
parsley = require 'parsleyjs'

require '../views/stop_title.jade'

Template.stopTitle.onCreated ->
  @activelyEditing = @data.activelyEditing
  @editingTitle = new ReactiveVar false

Template.stopTitle.onRendered ->
  $('.edit-title-form').parsley()

Template.stopTitle.helpers
  editingTitle: ->
    Template.instance().editingTitle.get()

  sortableOptions : ->
    handle: '.handle'

  editChildStop: (parent) ->
    Session.get("child-" + @stop.parent + '-' + @stop._id)

  isGroup: ->
    console.log @stop.type
    @stop.type is 'group'

Template.stopTitle.events
  'click .edit-title-btn' : (event, instance) ->
    editing = instance.editingTitle
    prop = "title-#{@stop._id}"
    if editing.get prop then value = 0 else value = 1
    editing.set prop, value

  'click .title': (event, instance)->
    editing = instance.activelyEditing
    editing.set not editing.get()

  'click .cancel-edit-title': (event, instance) ->
    instance.editingTitle.set false

  'submit .edit-title-form': (event, instance) ->
    event.preventDefault()
    stop = @stop
    Meteor.call 'updateTitle', stop, event.target.title.value, (err, res) ->
      instance.editingTitle.set false
