{ Tour } = require '../index'

Meteor.publish 'tours', ->
  Tour.find()

Meteor.publish 'tourDetails', (tourID) ->
  Tour.find tourID

Meteor.publish 'currentTours', ->
  today = new Date()
  Tour.find
    $and: [
      {
        openDate:
          $lte: today
      }
      {
        closeDate:
          $gte: today
      }
    ]

Meteor.publish 'archivedTour', ->
  today = new Date()
  Tour.find
    $query:
      closeDate:
        $lte: today
    $orderby: 'closeDate': -1
