{ showNotification } = require './notifications'
{ TourStop }         = require '../api/tour_stops/index'

saveStop = (stop, props, editing) ->
  stop = stop or new TourStop()
  stop.set props.values
  stop.save (error, id) ->
    console.error error, id
    if error
      showNotification error
    else
      showNotification()
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
  new Promise (resolve) ->
    if files.length
      uploading.set true
      S3.upload
        files      : files
        unique_name: false
        path       : tourID
        (error, response) ->
          uploading.set false
          if error
            showNotification message: "Something went wrong with the upload. Are you connected to the interwebs?"
            resolve(error)
          else
            resolve()
    else
      resolve()

updateStop = (stop, props, form, reactives) ->
  props = buildStop props, stop, form
  uploadFiles(props.files, props.values.tour, reactives.uploading)
    .then ->
      saveStop stop, props, reactives.editing

buildStop = (props, stop, form) ->
  baseValues =
    title    : form.title?.value or stop.title
    speaker  : form.speaker?.value
    mediaType: +form.mediaType?.value
    order    : +form.order?.value

  if props.files.length
    if form.media?.files[0]
      baseValues.media = form.media.files[0]?.name.split(" ").join("+")
    if baseValues.mediaType is 2 and form.posterImage?.files[0]
      baseValues.posterImage = form.posterImage.files[0].name.split(" ").join("+")

  props.values = _.extend props.values, baseValues
  props

formFiles = ($form) ->
  files = []
  _.each $form.find("[type='file']"), (file) ->
    if file.files[0] then files.push(file.files[0])
  files

getLastStopNum = (stops) ->
  _.last(stops)?.stopNumber

parsley = (formElement) ->
  $(formElement).parsley
    trigger: 'change'

stopEditing = (editing) ->
  Session.set 'editingAStop', false
  editing.set false

module.exports =
  saveStop       : saveStop
  updateStop     : updateStop
  uploadFiles    : uploadFiles
  getLastStopNum : getLastStopNum
  parsley        : parsley
  stopEditing    : stopEditing
  formFiles      : formFiles
