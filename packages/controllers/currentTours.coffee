if Meteor.isClient

  Template.currentTours.onCreated ->
    @subscribe 'currentTours'
    @subscribe 'currentTourStops'
    document.title = 'Current Tours'

  Template.currentTours.helpers
    tours: ->
      Tours.find()
    stopNumbers: ->
      stopNumbers = TourStops.find()
      console.log stopNumbers.fetch()
      obj = {}
      _.each stopNumbers, (stop) ->
        obj[stop.stopNumber] = {id: stop._id, tour: stop.tour}
      obj

    # type: ->
    #   if @tourType is 0
    #     'adult'
    #   else if @tourType is 1
    #     'family'


if Meteor.isServer

  Meteor.publish 'currentTours', ->
    Tours.find
      $and: [
        closeDate:
          $gte: today
        openDate:
          $lte: today
      ]

  Meteor.publish 'currentTourStops', ->
    tours = Tours.find()
      $and:
        [
          closeDate:
            $gte: today
          openDate:
            $lte: today
        ]
      fields:
        _id: 1

    query = _.map tours.fetch(), (tour)->
      {'tour': tour._id}

    TourStops.find
      $and:
        [
          $or: query
          $or: [type: 'single', type: 'group']
        ]
      fields:
        '_id': 1
        'tour': 1
        'stopNumber': 1
