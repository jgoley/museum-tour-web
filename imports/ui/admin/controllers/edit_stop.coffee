{ ReactiveVar } = require 'meteor/reactive-var'
{ TourStop }        = require '../../../api/tour_stops/index'
{ showNotification } = require '../../../helpers/notifications'
{ updateStop }       = require '../../../helpers/edit'

require './editing'
require './add_stop'
require './stop_title'
require './stop_title'
require './stop_data'
require '../../components/media_preview/media_preview.jade'
require '../../components/media_types/media_types.coffee'
require '../views/edit_stop.jade'


Template.editStop.onCreated ->
  @editingStop = new ReactiveVar false
  @addingStop = new ReactiveVar false
  @uploading = new ReactiveVar false
  @subscribe 'childStops', @data.stop._id

Template.editStop.helpers
  showChildStops: ->
    Template.instance().editingStop.get()

  editingStop: ->
    Template.instance().editingStop

  isEditingStop: ->
    Template.instance().editingStop.get()

  isAddingStop: ->
    Template.instance().addingStop.get()

  addingStop: ->
    Template.instance().addingStop

  notParent: ->
    not @stop.isGroup()

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
      that = @
      lastStopNumber = _.last(Template.instance().data.stops.fetch()).stopNumber
      TourStop.update {_id: that.stop.parent}, {$pull:{childStops: that.stop._id}}, () ->
        showNotification(e)

  'click .add-child': (event, instance) ->
    adding = instance.addingStop
    adding.set not adding.get()

  'click .cancel-add-stop': (event, instance) ->
    instance.addingStop.set false

  'click .delete': ->
    if @type is 'group'
      deleteStop = confirm('Are you sure you want to delete this stop?\nAll child stops will also be deleted!')
    else
      deleteStop = confirm('Are you sure you want to delete this stop?')
    if deleteStop
      if @type is 'group'
        Meteor.call 'removeGroup', @childStops
      else if @type is 'single'
        if @media
          deleteFile(@)
        TourStop.remove({_id: @_id})
      else
        that = @
        siblings = _.filter Template.instance().data.childStops.fetch(), (stop) ->
          stop.parent is that.parent
        higherSiblings = _.filter siblings, (stop) ->
          stop.order > that.order
        _.each higherSiblings, (stop) ->
          TourStop.update {_id: stop._id}, {$set: {order: stop.order-1}}
        TourStop.update({_id: @parent}, {$pull: {childStops: @_id}})
        TourStop.remove({_id: @_id})
