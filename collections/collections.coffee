@Tap = @Tap || {}
@Tap.Collections = {}

Tours = new Mongo.Collection 'tours'
TourStops = new Mongo.Collection 'tourStops'

@Tap.Collections.Tours = Tours
@Tap.Collections.TourStops = TourStops

Sortable.collections = ['tourStops']
today = moment(new Date()).format('YYYY-MM-DD')
if Meteor.isServer
  Meteor.publish 'tours', ->
    Tours.find()
  Meteor.publish 'tourDetails', (tourID) ->
    Tours.find({_id: tourID})
  Meteor.publish 'tourStops', (tourID) ->
    TourStops.find({'tour': tourID})
  Meteor.publish 'allStops', ->
    TourStops.find()
  Meteor.publish 'stop', (stopID) ->
    TourStops.find({'_id': stopID})
  Meteor.publish 'childStops', (stopID) ->
    TourStops.find({'parent': stopID}, {$sort: {order: 1}})
  Meteor.publish 'currentTours', ->
    Tours.find({$and: [{'closeDate': {$gte: today}},{'openDate': {$lte: today}}]})
  Meteor.publish 'currentTourStops', ->
    tours = Tours.find
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

  Meteor.publish 'archivedTours', ->
    Tours.find({$query: {'closeDate': {$lte: today}}, $orderby: {'openDate': -1}})

Tours.allow
  insert: (userId, doc) ->
    Meteor.user()
  update: (userId, doc, fields, modifier) ->
    Meteor.user()
  remove: (userId, doc) ->
    Meteor.user()

TourStops.allow
  insert: (userId, doc) ->
    Meteor.user()
  update: (userId, doc, fields, modifier) ->
    Meteor.user()
  remove: (userId, doc) ->
    Meteor.user()

stopTypes =
[
  {label: 'Audio', value: 1},
  {label: 'Video', value: 2},
  {label: 'Picture', value: 3},
  {label: 'Music', value: 4},
  {label: 'Film', value: 5}
]
