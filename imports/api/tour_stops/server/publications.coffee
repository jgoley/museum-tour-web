{ TourStops } = require '../../tour_stops/index'
{ Tours }     = require '../index'


Meteor.publish 'stop', (stopID) ->
  TourStops.find stopID

Meteor.publish 'childStops', (stopID) ->
  TourStops.find parent: stopID

Meteor.publish 'adjacentStops', (stopID) ->
  currentStop = TourStops.findOne stopID
  TourStops.find
    $and:[
      {tour: currentStop.tour}
      {$or: [{stopNumber: currentStop.stopNumber + 1}, {stopNumber: currentStop.stopNumber - 1}]}
    ]

Meteor.publish 'tourStops', (tourID) ->
  TourStops.find tour: tourID

Meteor.publish 'currentTourStops', ->
  today = moment(new Date()).format('YYYY-MM-DD')
  tours = Tours.find
    $and: [
      {
        closeDate:
          $gte: today
      },
      {
        openDate:
          $lte: today
      }
    ]
    {fields: {_id: 1}}

  query = _.map tours.fetch(), (tour)->
    {'tour': tour._id}

  TourStops.find
    $and: [
      {$or: query},
      {$or: [{type: 'single'}, {type: 'group'}]}
    ]
    {fields: {_id: 1, tour: 1, stopNumber: 1}}

Meteor.publish 'tourParentStops', (tourID) ->
  TourStops.find
    $and: [
      {tour: tourID}
      {$or:
        [
          {type: 'group'},
          {type: 'single'}
        ]
      }
    ]
    {$sort: {order: 1}}
