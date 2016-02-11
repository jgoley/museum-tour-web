if Meteor.isClient

  Template.currentTours.onCreated ->
    @subscribe 'currentTours'
    @subscribe 'currentTourStops'
    document.title = 'Current Tours'

  Template.currentTours.helpers
    tours: ->
      Tours.find()
    stopNumbers: ->
      TourStops.find()

if Meteor.isServer

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

