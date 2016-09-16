parsley              = require 'parsleyjs'
{ TourStop }         = require '../api/tour_stops/index'
{ go }               = require './route_helpers'
{ uploadFiles,
  formatFileName }   = require './files'

saveStop = (stop, props) ->
  new Promise (resolve, reject) ->
    _stop = stop or new TourStop()
    _stop.set props.values
    _stop.save (error, id) ->
      if error
        reject error
      else
        resolve null
        #update ord of stops higher than edited stop
          # if stop.order != values.values.order
          #   siblings = TourStop().find({$and: [
          #     { parent: stop.parent }
          #     { _id: $ne: stop._id }
          #     { order: $gte: +values.values.order }
          #   ]}).fetch()
          #   _.each siblings, (sibling, i) ->
          #     TourStop().update {_id: sibling._id}, {$set: {order: sibling.order + 1}}, (e,r) ->

updateStop = (stop, props, form, uploading) ->
  new Promise (resolve, reject) ->
    props = buildStop props, stop, form
    uploadFiles(props.files, props.values.tour, uploading)
      .then ->
        saveStop stop, props
      .then(resolve)
      .catch (error) ->
        reject error

buildStop = (props, stop, form) ->
  baseValues =
    title     : form.title?.value or stop.title
    speaker   : form.speaker?.value
    mediaType : +form.mediaType?.value
    order     : props.values.order or +form.order?.value

  if form.media?.files[0]
    baseValues.media = formatFileName form.media
  if form.posterImage?.files[0]
    baseValues.posterImage = formatFileName form.posterImage

  props.values = _.extend props.values, baseValues
  props

getLastStopNum = (stops) ->
  _.last(stops)?.stopNumber

parsley = (formElement) ->
  $(formElement).parsley
    trigger: 'change'

stopEditing = (editing) ->
  Session.set 'editingAStop', false
  editing.set false

updateSortOrder = (event, instance, baseNum) ->
  id = instance.$(event.item).data 'id'
  oldOrder = ++event.oldIndex + baseNum
  newOrder = ++event.newIndex + baseNum

  # Get the moved object
  movedTourStop = TourStop.findOne id
  movingUp = movedTourStop.stopNumber > newOrder
  query = []

  query.push _id: $ne: movedTourStop._id

  if movingUp
    query.push stopNumber: $gte: newOrder
    query.push stopNumber: $lte: oldOrder
  else
    query.push stopNumber: $lte: newOrder
    query.push stopNumber: $gt: oldOrder

  TourStop.find({$and: query}, {sort: stopNumber: 1}).forEach (stop) ->
    if movingUp then amount = 1 else amount = -1
    stop.stopNumber = stop.stopNumber + amount
    stop.save()

  movedTourStop.stopNumber = newOrder
  movedTourStop.save()


module.exports =
  saveStop            : saveStop
  updateStop          : updateStop
  getLastStopNum      : getLastStopNum
  parsley             : parsley
  stopEditing         : stopEditing
  updateSortOrder     : updateSortOrder
