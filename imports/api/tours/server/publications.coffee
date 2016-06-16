{ moment } = require 'meteor/momentjs:moment'
{ Tour }  = require '../index'

Meteor.publish 'tours', ->
  Tour.find()

Meteor.publish 'tourDetails', (tourID) ->
  Tour.find tourID

Meteor.publish 'currentTour', ->
  today = moment(new Date()).format('YYYY-MM-DD')
  Tour.find
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

Meteor.publish 'archivedTour', ->
  today = moment(new Date()).format('YYYY-MM-DD')
  Tour.find
    $query:
      closeDate:
        $lte: today
    $orderby: 'openDate': -1
