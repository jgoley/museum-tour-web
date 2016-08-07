{ ReactiveVar }      = require 'meteor/reactive-var'
{ TourStop }         = require '../../../api/tour_stops/index'
{ parsley }          = require '../../../helpers/edit'
{ stopEditing,
  updateStop,
  formFiles }        = require '../../../helpers/edit'
{ showNotification } = require '../../../helpers/notifications'

require '../views/editing.jade'

Template.editing.onCreated ->
  @mediaType = new ReactiveVar()
  @stop = @data.stop
  @mediaType.set @data.stop.mediaType
  @editingStop = @data.editingStop

Template.editing.onRendered ->
  @autorun =>
    if @editingStop.get()
      parsley '.edit-stop'

Template.editing.helpers
  parent: ->
    stop = Template.instance().stop
    stop.type is 'parent' or stop.type is 'group'

  parentStops: ->
    Template.instance().data.tour.getParentStops(@stop._id).fetch()

  mediaType: ->
    Template.instance().mediaType

Template.editing.events
  'click .cancel': (event, instance)->
    instance.editingStop.set false
    if @stop.isSingle()
      Session.set 'editingAStop', false
      return
    $('html, body').animate scrollTop: $('.group:not(.not-editing)').offset().top, 800

  'click .delete-file': ->
    deleteFile @stop

  'submit .edit-stop': (event, instance) ->
    event.preventDefault()

    form = event.target
    stop = instance.stop

    props =
      files: formFiles instance.$(form)
      values:
        tour: stop.tour

    updateStop(stop, props, form)
      .then ->
        showNotification()
      .catch (error) ->
        showNotification error

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
