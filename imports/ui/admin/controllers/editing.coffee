{ ReactiveVar } = require 'meteor/reactive-var'
{ TourStop }        = require '../../../api/tour_stops/index'
{ parsley }          = require '../../../helpers/edit'
{ setStopEditingState,
  stopEditing }         = require '../../../helpers/edit'

require '../views/editing.jade'

Template.editing.onCreated ->
  @mediaType = new ReactiveVar()
  @stop = @data.stop
  @mediaType.set @data.stop.mediaType
  @editingStop = @data.editingStop

Template.editing.onRendered ->
  parsley('.edit-stop')

Template.editing.helpers
  parent: ->
    stop = Template.instance().stop
    stop.type is 'parent' or stop.type is 'group'

  progress: () ->
    Math.round this.uploader.progress() * 100

  parentStops: ->
    TourStop.find {type: 'group'}, {sort: {title: 1}}

  getMediaType: ->
    Template.instance().mediaType

Template.editing.events
  'click .cancel': (event, instance)->
    stopEditing instance.editingStop

  'click .delete-file': ->
    deleteFile @stop

  'submit .add-to-group': (event, instance) ->
    e.preventDefault()
    parentID = e.target.parent.value
    data = instance.data
    stop = data.stop
    childStops = _.filter data.childStops.fetch(), (stop) -> stop.parent is parentID
    order = _.last(_.sortBy(childStops, 'order')).order + 1
    TourStop.update {_id: stop._id}, {$set: {type: 'child', parent: parentID, order: order} }, (e,r) ->
      TourStop.update {_id: parentID}, {$addToSet: {childStops: stop._id} }
      showNotification(e)
