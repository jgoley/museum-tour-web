@collections = @collections || {}
@schema = @schema || {}

@Tours = new Mongo.Collection 'tours'
@TourStops = new Mongo.Collection 'tourStops'

stopTypes = 
[
  {label: "Audio", value: 1},
  {label: "Video", value: 2},
  {label: "Picture", value: 3},
  {label: "Music", value: 4},
  {label: "Film", value: 5}
]

tourTypes = 
  [
    {label: "Adult - Temporary", value: 0}
    {label: "Family - Temporary", value: 1}
    {label: "Adult - Permanent", value: 2}
    {label: "Family - Permanent", value: 3}
  ]

icons = 
  [
    {label: "Ipod Graphic", value: 0}
    {label: "Gladys Leaf", value: 1}
  ]

menu = 
  [
    {label: "Yes", value: 0}
    {label: "No", value: 1}
  ]

if Meteor.isServer
  Meteor.publish "tours", () ->
    Tours.find()
  Meteor.publish "tourStops", (tourID) ->
    TourStops.find({"tourID": tourID})

Tours.attachSchema new SimpleSchema
  'mainTitle':
    type: String
    label: "Main Title"
    optional: true
  'subTitle':
    type: String
    label: "Sub Title"
    optional: true
  'openDate':
    type: Date
    label: "Opening Date"
    optional: true
  'closeDate':
    type: Date
    label: "Closing Date"
    optional: true
  'baseNum':
    type: String
    label: "Base Number"
    optional: true
  'tourType'
    type: String
    optional: true
    autoForm:
      type: "select",
      options: () ->
        tourTypes
  'icon'
    type: String
    optional: true
    autoform:
      type: "select",
      options: () ->
        icons
  'menu'
    type: String
    autoform:
      type: "select",
      options: () ->
        menu
  'image'
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: "file"

TourStops.attachSchema new SimpleSchema
  'stops':
    type: Array
    optional: true
    minCount: 1
    maxCount: Infinity
    autoform:
      afFieldInput:
        options: () ->
          minCount: 1
  'stops.$':
    type: Object
    optional: true
  'stops.$.title':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: 'text'
  'stops.$.title':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: 'text'
  'stops.$.group':
    type: String
    optional: true
    allowedValues: ['single', 'group'],
    autoform:
      options: [
        {value: 'single', label: 'Single stop'}
        {value: 'group', label: 'Group stop'}
      ]
      noselect: true

  'stops.$.speaker':
    type: String
    optional: true
  'stops.$.media':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: "file"
        template: "customFile"
  'stops.$.type':
    type: String
    optional: true
    autoform:
      type: "select",
      options: () ->
        stopTypes
  'stops.$.childStops':
    type: Array
    optional: true
    minCount: 1
    maxCount: Infinity
    label: "Child Stops"
  'stops.$.childStops.$':
    type: Object
    optional: true
  'stops.$.childStops.$.title':
    type: String
    optional: true
  'stops.$.childStops.$.speaker':
    type: String
    optional: true
  'stops.$.childStops.$.media':
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: "file"
  'stops.$.childStops.$.type':
    type: String
    optional: true
    autoform:
      type: "select",
      options: () ->
        stopTypes
