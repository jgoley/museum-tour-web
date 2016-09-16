require '../../../ui/components/file_upload/file_upload.coffee'
require '../../../ui/components/media_preview/media_preview.coffee'
require '../views/edit_media.jade'

Template.editMedia.helpers
  mediaIsImage: ->
    image = ['image', 3, '3']
    @currentMediaType in image or Template.instance().data.mediaType.get() in image

  mediaIsVideo: ->
    video = ['video', 2, '2', 'film', 5, '5']
    @mediaType?.get() in video or Template.instance().data.mediaType.get() in image

  posterImage: ->
    video = ['video', 2, '2']
    if @mediaType in video
      "#{Meteor.settings.public.awsUrl}/#{@stop.tour}/#{@stop.media}"
    else
      "#{Meteor.settings.public.awsUrl}/audio-poster.png"

  hasPosterImage: ->
    @stop?.posterImage

  requiresPosterImage: ->
    @mediaType?.get() in ['2','5', 2, 5]
