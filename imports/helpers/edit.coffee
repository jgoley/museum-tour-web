parsley              = require 'parsleyjs'
{ TourStop }         = require '../api/tour_stops/index'
{ go }               = require './route_helpers'

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

uploadFiles = (files, tourID, uploading) ->
  new Promise (resolve, reject) ->
    resolve() if not files.length
    uploading.set true
    S3.upload
      files      : files
      unique_name: false
      path       : tourID
      (error, response) ->
        uploading.set false
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

formFiles = ($form) ->
  files = []
  _.each $form.find("[type='file']"), (file) ->
    if file.files[0] then files.push(file.files[0])
  files

formatFileName = (file) ->
  file.files[0]?.name.split(' ').join '+'

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
  uploadFiles         : uploadFiles
  getLastStopNum      : getLastStopNum
  parsley             : parsley
  stopEditing         : stopEditing
  formFiles           : formFiles
  formatFileName      : formatFileName
