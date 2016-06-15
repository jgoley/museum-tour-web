{ moment } = require 'meteor/momentjs:moment'
{ Tours }  = require '../index'

Meteor.publish 'tours', ->
  Tours.find()

Meteor.publish 'tourDetails', (tourID) ->
  Tours.find tourID

Meteor.publish 'currentTours', ->
  today = moment(new Date()).format('YYYY-MM-DD')
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

Meteor.publish 'archivedTours', ->
  today = moment(new Date()).format('YYYY-MM-DD')
  Tours.find
    $query:
      closeDate:
        $lte: today
    $orderby: 'openDate': -1
