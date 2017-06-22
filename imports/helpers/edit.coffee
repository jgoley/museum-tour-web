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

  speaker = form.speaker?.value
  if speaker
    baseValues.peaker = speaker

  order = props.values.order or +form.order?.value
  if order
    baseValues.order = order

  mediaType = +form.mediaType?.value
  if mediaType
    baseValues.mediaType = mediaType

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
