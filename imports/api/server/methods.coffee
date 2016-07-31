{ Tour }             = require '../tours/index'
{ TourStop }         = require '../tour_stops/index'
{ showNotification } = require '../../helpers/notifications'
{ go }               = require '../../helpers/route_helpers'

Meteor.methods
  deleteTour: (id) ->
    Tour.remove id

  deleteTourStop: (id) ->
    TourStop.remove id

  updateTitle: (stop, title) ->
    stop.set title: title
    stop.save()

  deleteTourImage: (tour)->
    path = "/#{tour.tourID}/#{tour.image}"
    S3.delete(path, (e,s)-> console.log e,s)
    Tour.update({_id: tour.tourID}, {$set:{image: ''}})
