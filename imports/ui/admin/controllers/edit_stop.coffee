import { ReactiveVar } from 'meteor/reactive-var'
import { TourStop } from '../../../api/tour_stops/index'
import { showNotification } from '../../../helpers/notifications'
import { updateStop } from '../../../helpers/edit'

import './editing'
import './add_stop'
import './stop_title'
import './stop_title'
import './stop_data'
import '../../components/media_preview/media_preview.jade'
import '../../components/media_types/media_types.coffee'
import '../views/edit_stop.jade'


Template.editStop.onCreated ->
  @editingStop = new ReactiveVar false
  @addingStop = new ReactiveVar false
  @uploading = new ReactiveVar false
  @deleting = new ReactiveVar false
  @stopID = @data.stop._id
  @subscribe 'childStops', @stopID, =>
    unless TourStop.findOne(parent: @stopID)
      @addingStop.set true

Template.editStop.helpers
  editingStop: ->
    Template.instance().editingStop

  isEditingStop: ->
    Template.instance().editingStop.get()

  isAddingStop: ->
    instance = Template.instance()
    if not TourStop.findOne(parent: @stop._id)
      instance.addingStop.set true
    instance.addingStop.get()

  addingStop: ->
    Template.instance().addingStop

  notParent: ->
    not @stop.isGroup()

  hasChildren: ->
    TourStop.findOne(parent: Template.instance().data.stop._id)?

  deleting: ->
    Template.instance().deleting

Template.editStop.events
  'click .convert-group': ->
    convertStop = confirm('Are you sure you want to convert this stop to a group?')
    if convertStop
      currentStop = @stop
      newChild = _.clone currentStop
      delete newChild._id
      delete newChild.stopNumber
      newChild.parent = currentStop._id
      newChild.type = 'child'
      newChild.order = 1
      parentQuery = "}, {$set: {type: 'group'}}"
      TourStop.insert newChild, (e, id) ->
        TourStop.update {_id: currentStop._id}, {$set: {type:'group', childStops: [id]}, $unset: {media: '', mediaType: '', speaker: ''}}, (e,r) ->
          showNotification(e)

  'click .convert-single': ->
    convertStop = confirm('Are you sure you want to convert this stop to a single stop?')
    if convertStop
      lastStopNumber = _.last(Template.instance().data.stops.fetch()).stopNumber
      TourStop.update {_id: @stop.parent}, {$pull:{childStops: @stop._id}}, () ->
        showNotification(e)
