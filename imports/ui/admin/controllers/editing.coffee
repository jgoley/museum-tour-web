import { ReactiveVar } from 'meteor/reactive-var'
import { TourStop } from '../../../api/tour_stops/index'
import { parsley,
         stopEditing,
         updateStop }        from '../../../helpers/edit'
import { formFiles }         from '../../../helpers/files'
import { showNotification }  from '../../../helpers/notifications'

import '../views/editing.jade'

Template.editing.onCreated ->
  @mediaType = new ReactiveVar()
  @stop = @data.stop
  @mediaType.set @data.stop.mediaType
  @editingStop = @data.editingStop
  @subscribe 'parentTourStops', @stop._id

Template.editing.onRendered ->
  @autorun =>
    if @editingStop.get()
      parsley '.edit-stop'

Template.editing.helpers
  parent: ->
    stop = Template.instance().stop
    stop.type is 'parent' or stop.type is 'group'

  parentStops: ->
    TourStop.find
      $and:
        [
          _id: {$ne: @stop._id}
          tour: @_id
          $or:
            [
              {type: 'group'},
              {type: 'single'}
            ]
        ]
      {sort: stopNumber: 1}

  mediaType: ->
    Template.instance().mediaType

Template.editing.events
  'click .cancel': (event, instance)->
    instance.editingStop.set false
    if @stop.isSingle()
      Session.set 'editingAStop', false
      return
    headerHeight = Meteor.settings.public.headerHeight
    $('html, body').animate
      scrollTop: $('.group:not(.not-editing)').offset().top - headerHeight
    , 800

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
