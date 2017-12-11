import { ReactiveVar } from 'meteor/reactive-var'
import './audioContent.jade'
import convertPlayTime from '../../../helpers/play_time'

Template.audioContent.onCreated ->
  @stop = @data.stop
  isSingle = @stop.isSingle()
  @playing = new ReactiveVar(isSingle)
  @currentTime = new ReactiveVar(0)
  @stopLength = new ReactiveVar(0)
  @stopLoaded = new ReactiveVar(false)
  @active = new ReactiveVar(isSingle)
  @setProgress = null

Template.audioContent.onRendered ->
  @stopAudioEl = @$('audio')[0]

  @updateProgress = =>
    @currentTime.set(@stopAudioEl.currentTime)

  @autorun =>
    playing = @playing.get()
    if playing
      @setProgress = setInterval((=>
        @updateProgress()
      ), 100)
    else
      clearInterval(@setProgress)

Template.audioContent.helpers
  playing: ->
    Template.instance().playing.get()

  controlState: ->
    instance = Template.instance()
    unless instance.stopLoaded.get()
      return 'loading'
    if instance.playing.get()
      'pause'
    else
      'play'

  stopLoaded: ->
    Template.instance().stopLoaded.get()

  playProgress: ->
    instance = Template.instance()
    currentTime = instance.currentTime.get()
    stopLength = instance.stopLength.get()
    if currentTime == stopLength
      return 0
    Math.ceil((currentTime / stopLength) * 100)

  currentTime: ->
    convertPlayTime( Template.instance().currentTime.get() )

  stopLength: ->
    convertPlayTime( Template.instance().stopLength?.get() )

  loaded: ->
    Template.instance().stopLoaded.get()

  active: ->
    Template.instance().active.get()

  autoplay: ->
    Template.instance().stop.isSingle()

Template.audioContent.events
  'click .audio-track,
   click .audio-control': (event, instance) ->
    stopAudioEl = instance.stopAudioEl
    $('audio, video').not(stopAudioEl).each -> @pause()
    playing = not stopAudioEl.paused
    if playing
      stopAudioEl.pause()
    else
      stopAudioEl.play()
      instance.active.set(true)
    instance.playing.set(not playing)

  'loadeddata audio': (event, instance) ->
    instance.stopLoaded.set(true)

  'loadedmetadata audio': (event, instance) ->
    instance.stopLength.set(instance.$('audio')[0].duration)
    instance.data.stopLength.set(event.currentTarget.duration)

  'ended audio': (event, instance) ->
    instance.active.set(false)
    instance.playing.set(false)

  'pause audio': (event, instance) ->
    instance.playing.set(false)
    clearInterval(@setProgress)
