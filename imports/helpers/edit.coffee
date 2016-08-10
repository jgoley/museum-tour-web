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
    title    : form.title?.value or stop.title
    speaker  : form.speaker?.value
    mediaType: +form.mediaType?.value
    order    : props.values.order or +form.order?.value

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


module.exports =
  saveStop            : saveStop
  updateStop          : updateStop
  getLastStopNum      : getLastStopNum
  parsley             : parsley
  stopEditing         : stopEditing
