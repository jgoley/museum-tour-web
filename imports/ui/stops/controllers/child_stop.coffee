import { ReactiveVar } from 'meteor/reactive-var'
import '../views/child_stop.jade'

convertPlayTime = (time) ->
  if not time
    return '00:00'
  sec_num = parseInt(time, 10)
  hours   = Math.floor(sec_num / 3600)
  minutes = Math.floor((sec_num - (hours * 3600)) / 60)
  seconds = sec_num - (hours * 3600) - (minutes * 60)
  if minutes < 10
    minutes = '0' + minutes
  if seconds < 10
    seconds = '0' + seconds
  minutes + ':' + seconds

Template.childStop.onCreated ->
  @stopLength = new ReactiveVar('')

Template.childStop.helpers
  stopLength: ->
    Template.instance().stopLength

  stopLengthValue: ->
    convertPlayTime(Template.instance().stopLength.get())
