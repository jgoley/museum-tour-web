require '../../../ui/components/file_upload/file_upload.coffee'
require '../../../ui/components/media_preview/media_preview.jade'
require '../views/edit_media.jade'

Template.editMedia.helpers
  'mediaIsImage': ->
    image = ['image', 3, '3']
    @currentMediaType in image
  'mediaIsVideo': ->
    video = ['video', 2, '2', 'film', 5, '5']
    @mediaType?.get() in video

Template.editMedia.events
  'click .delete-media': (e, template) ->
    Meteor.call 'deleteMedia', 'media', @stop.media, @stop._id, @stop.tour
  'click .delete-image': (e, template) ->
    Meteor.call 'deleteMedia', @typeName, @media, @stop?._id, @tourID
