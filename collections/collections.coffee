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
    tours = Tours.find({$and: [{'closeDate': {$gte: today}},{'openDate': {$lte: today}}]}, {fields:{'_id': 1}}).fetch()
    query = _.map tours, (tour)->
      {'tour': tour._id}
    TourStops.find({$and: [{$or: query}, {$or:[{'type': 'single'},{'type': 'group'}]}]}, {fields: {'_id': 1, 'tour': 1, 'stopNumber': 1}})
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

# Tours.attachSchema new SimpleSchema
#   'mainTitle':
#     type: String
#     label: 'Main Title'
#     optional: true
#   'subTitle':
#     type: String
#     label: 'Sub Title'
#     optional: true
#   'openDate':
#     type: Date
#     label: 'Opening Date'
#     optional: true
#   'closeDate':
#     type: Date
#     label: 'Closing Date'
#     optional: true
#   'baseNum':
#     type: String
#     label: 'Base Number'
#     optional: true
#   'tourType':
#     type: Number
#     allowedValues: [0, 1, 2, 3]
#     optional: true
#     autoform:
#       options:
#         [
#           {label: 'Adult - Temporary', value: 0},
#           {label: 'Family - Temporary', value: 1},
#           {label: 'Adult - Permanent', value: 2},
#           {label: 'Family - Permanent', value: 3}
#         ]
#   'menu':
#     type: Boolean,
#     defaultValue: false,
#     label: "Show stop type menu?"
#   'image':
#     type: String
#     optional: true
#     autoform:
#       afFieldInput:
#         type: 'file'
#   'stops':
#     type: Array
#     optional: true
#   'stops.$':
#     type: String
#     optional: true

