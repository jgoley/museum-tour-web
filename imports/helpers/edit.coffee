{ showNotification } = require './notifications'

updateStop = (stop, values, method) ->
  if values.files.length
    Meteor.call 'uploadFile', values.files, values.values.tour, (err,res)->
      if err
        throw new Meteor.Error err.reason
      else
        Meteor.call 'saveStop', stop, values, method, (err, res) ->
          if err
            showNotification(err.reaon, sessionString)
          else
            showNotification(err, sessionString)
            Session.set('add-stop', false)
            Session.set('creating-stop', false)
            Session.set(id,true)

  else
     Meteor.call 'saveStop', stop, values, method, (err, res) ->
      if err
        showNotification(err.reaon, sessionString)
      else
        showNotification(err, sessionString)
        Session.set('add-stop', false)
        Session.set('creating-stop', false)
        Session.set(id,true)

showStop = (instance, stop) ->
  editing = instance.data.activelyEditing
  editing.set not editing.get()

getLastStopNum = (stops) ->
  _.last(stops)?.stopNumber

parsley = (formElement) ->
  $(formElement).parsley
    trigger: 'change'


module.exports =
  updateStop    : updateStop
  showStop      : showStop
  getLastStopNum: getLastStopNum
  parsley       : parsley
