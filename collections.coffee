@collections = @collections || {}
@schema = @schema || {}

@Tours = new Mongo.Collection 'tours'
@TourStops = new Mongo.Collection 'tourStops'

stopTypes = 
[
  {label: 'Audio', value: 1},
  {label: 'Video', value: 2},
  {label: 'Picture', value: 3},
  {label: 'Music', value: 4},
  {label: 'Film', value: 5}
]

if Meteor.isServer
  Meteor.publish 'tours', () ->
    Tours.find()
  Meteor.publish 'tourStops', (tourID) ->
    TourStops.find({'tour': tourID})
  Meteor.publish 'stop', (stopID) ->
    TourStops.find({'_id': stopID})

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

TourStops.attachSchema new SimpleSchema
  'tour':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: 'hidden'
  'stopNumber':
    type: Number
    optional: true
    autoform:
      afFieldInput:
        type: 'hidden'
  'title':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: 'text'
  'type':
    type: String
    optional: true
    allowedValues: ['single', 'group'],
    autoform:
      options: [
        {value: 'single', label: 'Single stop'}
        {value: 'group', label: 'Group stop'}
      ]
      noselect: true
  'speaker':
    type: String
    optional: true
  'media':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: 'file'
        template: 'customFile'
  'mediaType':
    type: Number
    optional: true
    autoform:
      type: 'select',
      options: () ->
        stopTypes
  'childStops':
    type: Array
    optional: true
    minCount: 1
    maxCount: Infinity
    label: 'Child Stops'
  'childStops.$':
    type: Object
    optional: true
  'childStops.$.title':
    type: String
    optional: true
  'childStops.$.speaker':
    type: String
    optional: true
  'childStops.$.media':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: 'file'
  'childStops.$.mediaType':
    type: Number
    optional: true
    autoform:
      type: 'select',
      options: () ->
        stopTypes
