require './media_preview.jade'

Template.mediaPreview.events
  'click .delete-image': (event, instance) ->
    @stop.deleteMedia()
