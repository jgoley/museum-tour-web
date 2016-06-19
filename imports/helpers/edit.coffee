{ showNotification } = require './notifications'
{ TourStop }         = require '../api/tour_stops/index'

saveStop = (stop, props, reactives) ->
  stop = stop or new TourStop()
  stop.set props.values
  stop.save (error, id) ->
    console.error error, id
    if error
      showNotification error
    else
      reactives.addingStop.set false
      reactives.creatingStop.set false
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

uploadFile = (files, tourID) ->
  new Promise (resolve) ->
    S3.upload
      files:files
      unique_name: false
      path: tourID
      (error, response) ->
        if error
          showNotification message: "Something went wrong with the upload. Are you connected to the interwebs?"
          resolve(error)
        else
          resolve()

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
  uploadFile     : uploadFile
  getLastStopNum : getLastStopNum
  parsley        : parsley
  stopEditing    : stopEditing
