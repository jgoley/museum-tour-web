{ showNotification } = require '../../helpers/notifications'
{ go }               = require '../../helpers/route_helpers'

Meteor.methods
  deleteTour: (id) ->
    Tour.remove id

  deleteFile: (stop)->
    path = "#{stop.tour}/#{stop.media}"
    S3.delete path, (e,s)-> console.log e,s
    stop.set media: ''
    stop.save()
    TourStop().update({_id: stop._id}, {$set:{media: ''}})

  deleteFolder: (tourID) ->
    path = "#{tourID}"
    S3.delete path, (e,s)-> console.log e,s

  removeGroup: (childStops) ->
    _.each childStops, (childStopId) ->
      childStop TourStop().findOne({_id:childStopId})
      if childStop.media
        deleteFile(childStop)
      removeStop(@id, Template.instance())
    TourStop.remove @_id

  removeStop: (stopID, template) ->
    stopNumber = @stopNumber
    higherStops = _.filter template.data.stops.fetch(), (stop) ->
      stop.stopNumber > stopNumber
    _.each higherStops, (stop) ->
      TourStop.update {_id: stop._id}, {$set: {stopNumber: stop.stopNumber-1}}
    TourStop.remove({_id: stopID})

  updateTitle: (stop, title) ->
    stop.set title: title
    stop.save()

  deleteTourImage: (tour)->
    path = "/#{tour.tourID}/#{tour.image}"
    S3.delete(path, (e,s)-> console.log e,s)
    Tour.update({_id: tour.tourID}, {$set:{image: ''}})


  # uploadFile: (files, tour) ->
  #   new Promise (resolve, reject) ->
  #     S3.upload
  #       files:files
  #       unique_name: false
  #       path: tour
  #       (e,r) ->
  #         console.log e, r
  #         resolve(r)
