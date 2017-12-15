import { ReactiveVar } from 'meteor/reactive-var'
import '../views/child_stop.jade'
import convertPlayTime from '../../../helpers/play_time'

Template.childStop.onCreated ->
  @stopLength = new ReactiveVar('')

Template.childStop.helpers
  stopLength: ->
    Template.instance().stopLength

  stopLengthValue: ->
    convertPlayTime(Template.instance().stopLength.get())
