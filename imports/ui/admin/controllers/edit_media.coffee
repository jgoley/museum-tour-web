require '../../../ui/components/file_upload/file_upload.coffee'
require '../../../ui/components/media_preview/media_preview.coffee'
require '../views/edit_media.jade'

Template.editMedia.helpers
  mediaIsImage: ->
    image = ['image', 3, '3']
    @currentMediaType in image
  mediaIsVideo: ->
    video = ['video', 2, '2', 'film', 5, '5']
    @mediaType?.get() in video
  posterImage: ->
    video = ['video', 2, '2']
    if @mediaType in video
      "#{Meteor.settings.public.awsUrl}/#{@stop.tour}/#{@stop.media}"
    else
      "#{Meteor.settings.public.awsUrl}/audio-poster.png"


Template.editMedia.events
  'click .delete-media': (event, instance) ->
    @stop.deleteMedia()
