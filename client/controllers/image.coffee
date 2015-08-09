Tours = ()->
  @Tap.Collections.Tours

deleteFile = (tour)->
  console.log tour
  path = "/#{tour.tourID}/#{tour.image}"
  console.log path
  S3.delete(path, (e,s)-> console.log e,s)
  Tours().update({_id: tour.tourID}, {$set:{image: ''}})

Template.image.events
  'click .delete-tour-image': (e, template) ->
    deleteFile(template.data)
