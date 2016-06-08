{Meteor}   = require 'meteor/meteor'
{Template} = require 'meteor/templating'

require '../views/edit_media.jade'

Template.editMedia.helpers
  'mediaIsImage': ->
    image = ['image', 3, '3']
    @currentMediaType in image
  'mediaisVideo': ->
    video = ['video', 2, '2']
    @mediaType?.get() in video

Template.editMedia.events
  'click .delete-media': (e, template) ->
    Meteor.call 'deleteMedia', 'media', @stop.media, @stop._id, @stop.tour
  'click .delete-image': (e, template) ->
    Meteor.call 'deleteMedia', @typeName, @media, @stop?._id, @tourID
