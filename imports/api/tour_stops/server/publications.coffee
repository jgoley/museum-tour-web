{ Tour }     = require '../../tours/index'
{ TourStop } = require '../index'
moment       = require 'momentjs'

Meteor.publish 'stop', (stopID) ->
  TourStop.find stopID

Meteor.publish 'childStops', (stopID) ->
  TourStop.find parent: stopID

Meteor.publish 'adjacentStops', (stopID) ->
  tourStop = TourStop.findOne stopID
  tourStop.getAdjacentStops()

Meteor.publish 'tourStops', (tourID) ->
  TourStop.find tour: tourID

Meteor.publish 'currentTourStops', ->
  today = moment(new Date()).format 'YYYY-MM-DD'
  currentTours =
    Tours.find
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

  query = _.map currentTours.fetch(), (tour) ->
    {'tour': tour._id}

  TourStop.find
    $and: [
      {$or: query},
      {$or: [{type: 'single'}, {type: 'group'}]}
    ]
    {fields: {_id: 1, tour: 1, stopNumber: 1}}

Meteor.publish 'tourParentStops', (tourID) ->
  tour = Tour.findOne tourID
  tour.getParentStops()
