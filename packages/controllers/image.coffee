if Meteor.isClient

  Template.image.events
    'click .delete-tour-image': (e, template) ->
      Meteor.call 'deleteTourImage', template.data

Meteor.methods

  deleteTourImage: (tour)->
    path = "/#{tour.tourID}/#{tour.image}"
    S3.delete(path, (e,s)-> console.log e,s)
    Tours.update({_id: tour.tourID}, {$set:{image: ''}})
