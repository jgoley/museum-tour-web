import './s3_config'
import './register_api'
import { TourStops } from '/imports/api/tour_stops/index'

Meteor.startup ->
  TourStops.find(
    mediaType: $in: [NaN, undefined]
    type: 'group'
  ).forEach (stop) ->
    TourStops.update _id: stop._id,
      $unset:
        mediaType: ''
        order: ''

  TourStops.remove({'tour': null})
