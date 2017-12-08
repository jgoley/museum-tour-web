import './audioContent.jade'
import { ReactiveVar } from 'meteor/reactive-var'

Template.audioContent.onCreated ->
  @stop = @data.stop
  @playing = new ReactiveVar(false)
  @currentTime = new ReactiveVar(0)
  @stopLength = new ReactiveVar(0)
  @stopLoaded = new ReactiveVar(false)
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
    if Template.instance().playing.get()
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
    Template.instance().currentTime.get()

  stopLength: ->
    Template.instance().playTime.get()

  loaded: ->
    Template.instance().stopLoaded.get()

Template.audioContent.events
  'click .audio-control': (event, instance) ->
    stopAudioEl = instance.stopAudioEl
    playing = not stopAudioEl.paused
    if playing
      stopAudioEl.pause()
    else
      stopAudioEl.play()
    instance.playing.set(not playing)

  'loadeddata audio': (event, instance) ->
    instance.stopLoaded.set(true)

  'loadedmetadata audio': (event, instance) ->
    instance.stopLength.set(instance.$('audio')[0].duration)

  'ended audio': (event, instance) ->
    instance.playing.set(playing)

  'ended audio': (event, instance) ->
    instance.playing.set(false)
