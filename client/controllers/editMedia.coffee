Tours = ()->
  @Tap.Collections.Tours

deleteFile = (tour)->
  console.log tour
  path = "/#{tour.tourID}/#{tour.image}"
  console.log path
  S3.delete(path, (e,s)-> console.log e,s)
  Tours().update({_id: tour.tourID}, {$set:{image: ''}})

Template.editMedia.helpers
  'mediaIsImage': ->
    image = ['image', 3, '3']
    @mediaType.get() in image

Template.editMedia.events
  'click .delete-media': (e, template) ->
    deleteFile(template.data)
