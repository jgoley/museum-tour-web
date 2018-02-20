import { ReactiveVar } from 'meteor/reactive-var'
import { Asset } from '../../api/assets/index'
import { analytics } from 'meteor/okgrow:analytics'
import './help.jade'

Template.help.onCreated ->
  title = 'Help'
  document.title = title
  analytics.page(title)
  @loading = new ReactiveVar(true)
  @baseUrl = Meteor.settings.public.awsUrl

  @subscribe 'helpVideoAssets', ['help-video', 'help-video-poster'], =>
    @loading.set(false)

Template.help.onRendered ->
  # Delay start of video by a second so as to not suprise user
  Meteor.setTimeout =>
    @$('video').get(0).play()
  , 1000

Template.help.helpers
  isLoading: ->
    Template.instance().loading.get()

  videoPath: ->
    video = Asset.findOne(name: 'help-video')
    if video
      name = video.location + video.fileName
      "#{Template.instance().baseUrl}/#{name}"
    else
      "#{Template.instance().baseUrl}/help.mp4"

  posterPath: ->
    poster = Asset.findOne(name: 'help-video-poster')
    if poster
      name = poster.location + poster.fileName
      "#{Template.instance().baseUrl}/#{name}"
