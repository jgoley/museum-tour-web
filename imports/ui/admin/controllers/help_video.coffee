import { ReactiveVar } from 'meteor/reactive-var'
import { uploadFiles,
         formatFileName,
         formFiles } from '../../../helpers/files'
import { showNotification} from '../../../helpers/notifications'
import { Asset } from '../../../api/assets/index'

import '../views/help_video.jade'

Template.helpVideo.onCreated ->
  @loading = new ReactiveVar(true)
  @uploading = new ReactiveVar(false)

  @subscribe 'helpVideoAssets', ['help-video', 'help-video-poster'], =>
    @loading.set(false)

  @createFile = (form, name, type) =>
    file = formFiles($(form))[0]
    asset = new Asset()
    asset.set
      name: name
      fileName: file.name
      type: type
      location: 'assets/'
    asset.upload(file, 'assets').then ->
      asset.save()

Template.helpVideo.helpers
  uploading: ->
    Template.instance().uploading.get()

  video: ->
    Asset.findOne(name: 'help-video')

  videoPath: ->
    video = Asset.findOne(name: 'help-video')
    if video
      video.location + video.fileName

  poster: ->
    Asset.findOne(name: 'help-video-poster')

  posterPath: ->
    poster = Asset.findOne(name: 'help-video-poster')
    if poster
      poster.location + poster.fileName

  isLoading: ->
    Template.instance().loading.get()

Template.helpVideo.events
  'submit .js-help-video': (event, instance) ->
    event.preventDefault()
    instance.createFile(event.target, 'help-video', 'video')

  'submit .js-help-poster': (event, instance) ->
    event.preventDefault()
    instance.createFile(event.target, 'help-video-poster', 'image')
