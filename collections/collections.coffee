@Tap = @Tap || {}
@Tap.Collections = {}

Tours = new Mongo.Collection 'tours'
TourStops = new Mongo.Collection 'tourStops'

@Tap.Collections.Tours = Tours
@Tap.Collections.TourStops = TourStops

Sortable.collections = ['tourStops']

if Meteor.isServer
  Meteor.publish 'tours', ->
    Tours.find()
  Meteor.publish 'tourStops', (tourID) ->
    TourStops.find({'tour': tourID})
  Meteor.publish 'allStops', ->
    TourStops.find()
  Meteor.publish 'stop', (stopID) ->
    TourStops.find({'_id': stopID})
  Meteor.publish 'childStops', (stopID) ->
    TourStops.find({'parent': stopID}, {$sort: {order: 1}})
  Meteor.publish 'currentTours', ->
    today = new Date()
    Tours.find({$and: [{'closeDate': {$gte: today}},{'openDate': {$lte: today}}]})
  Meteor.publish 'currentTourStops', ->
    today = new Date()
    tours = Tours.find({$and: [{'closeDate': {$gte: today}},{'openDate': {$lte: today}}]}, {fields:{'_id': 1}}).fetch()
    query = _.map tours, (tour)->
      {'tour': tour._id}
    TourStops.find({$and: [{$or: query}, {$or:[{'type': 'single'},{'type': 'group'}]}]}, {fields: {'_id': 1, 'tour': 1, 'stopNumber': 1}})
  Meteor.publish 'archiveTours', ->
    today = new Date()
    Tours.find({'closeDate': {$lte: today}})

Tours.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fields, modifier) ->
    true
  remove: (userId, doc) ->
    true

TourStops.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fields, modifier) ->
    true
  remove: (userId, doc) ->
    true

stopTypes =
[
  {label: 'Audio', value: 1},
  {label: 'Video', value: 2},
  {label: 'Picture', value: 3},
  {label: 'Music', value: 4},
  {label: 'Film', value: 5}
]

Tours.attachSchema new SimpleSchema
  'mainTitle':
    type: String
    label: 'Main Title'
    optional: true
  'subTitle':
    type: String
    label: 'Sub Title'
    optional: true
  'openDate':
    type: Date
    label: 'Opening Date'
    optional: true
  'closeDate':
    type: Date
    label: 'Closing Date'
    optional: true
  'baseNum':
    type: String
    label: 'Base Number'
    optional: true
  'tourType':
    type: Number
    allowedValues: [0, 1, 2, 3]
    optional: true
    autoform:
      options:
        [
          {label: 'Adult - Temporary', value: 0},
          {label: 'Family - Temporary', value: 1},
          {label: 'Adult - Permanent', value: 2},
          {label: 'Family - Permanent', value: 3}
        ]
  'menu':
    type: Boolean,
    defaultValue: false,
    label: "Show stop type menu?"
  'image':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: 'file'
  'stops':
    type: Array
    optional: true
  'stops.$':
    type: String
    optional: true

