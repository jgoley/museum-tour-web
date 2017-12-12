import { ReactiveVar } from 'meteor/reactive-var'
import './audioContent.jade'
import convertPlayTime from '../../../helpers/play_time'

Template.audioContent.onCreated ->
  @stop = @data.stop
  @playing = new ReactiveVar(false)
  @currentTime = new ReactiveVar(0)
  @stopLength = new ReactiveVar(0)
  @active = new ReactiveVar(false)
  @stopLoading = new ReactiveVar(false)
  @stopCanPlay = new ReactiveVar(false)
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
    if instance.stopLoading.get()
      return 'loading'
    if instance.playing.get()
      'pause'
    else
      'play'

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
    not Template.instance().stopLoading.get()

  active: ->
    Template.instance().active.get()

Template.audioContent.events
  'click .audio-track,
   click .audio-control': (event, instance) ->
    stopAudioEl = instance.stopAudioEl
    playing = not stopAudioEl.paused
    if not playing and not instance.stopCanPlay.get()
      instance.stopLoading.set(true)
    $('audio, video').not(stopAudioEl).each -> @pause()
    if playing
      stopAudioEl.pause()
    else
      stopAudioEl.play()
      instance.active.set(true)
    instance.playing.set(not playing)

  'canplaythrough audio': (event, instance) ->
    instance.stopLoading.set(false)
    instance.stopCanPlay.set(true)

  'loadedmetadata audio': (event, instance) ->
    instance.stopLength.set(instance.$('audio')[0].duration)
    instance.data.stopLength.set(event.currentTarget.duration)

  'ended audio': (event, instance) ->
    instance.active.set(false)
    instance.playing.set(false)
    instance.currentTime.set(0)

  'pause audio': (event, instance) ->
    instance.playing.set(false)
    clearInterval(@setProgress)
