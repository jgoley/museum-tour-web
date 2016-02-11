if Meteor.isClient

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

Meteor.methods

  deleteMedia: (prop, fileName, stopID, tourID)->
    path = "/#{tourID}/#{fileName}"
    S3.delete(path, (e,s)-> console.log e,s)
    newProp = {}
    newProp[prop] = ''
    if stopID
      TourStops().update({_id: stopID}, {$set:newProp})
    else
      Tours().update({_id: tourID}, {$set:newProp})
