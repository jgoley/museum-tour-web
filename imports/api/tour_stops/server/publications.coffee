{ TourStop } = require '../../tour_stops/index'
{ Tour }     = require '../index'


Meteor.publish 'stop', (stopID) ->
  TourStop.find stopID

Meteor.publish 'childStops', (stopID) ->
  TourStop.find parent: stopID

Meteor.publish 'adjacentStops', (stopID) ->
  currentStop = TourStop.findOne stopID
  TourStop.find
    $and:[
      {tour: currentStop.tour}
      {$or: [{stopNumber: currentStop.stopNumber + 1}, {stopNumber: currentStop.stopNumber - 1}]}
    ]

Meteor.publish 'tourStops', (tourID) ->
  TourStop.find tour: tourID

Meteor.publish 'currentTourStop', ->
  today = moment(new Date()).format('YYYY-MM-DD')
  tours = Tour.find
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

  TourStop.find
    $and: [
      {$or: query},
      {$or: [{type: 'single'}, {type: 'group'}]}
    ]
    {fields: {_id: 1, tour: 1, stopNumber: 1}}

Meteor.publish 'tourParentStops', (tourID) ->
  TourStop.find
    $and: [
      {tour: tourID}
      {$or:
        [
          {type: 'group'},
          {type: 'single'}
        ]
      }
    ]
