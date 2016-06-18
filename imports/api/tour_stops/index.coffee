{ Mongo } = require 'meteor/mongo'
{ Class } = require 'meteor/jagi:astronomy'

TourStops = new Mongo.Collection 'tourStops'
TourStop = Class.create
  name: 'TourStop'
  collection: TourStops
  fields:
    tour: String
    parent: String
    type: String
    title: String
    stopNumber: Number
    speaker: String
    media: String
    mediaType: Number
    order: Number

  methods:
    children: ->
      TourStop.find parent: @_id

    isVideo: ->
      @mediaType in ['2',2,'5',5]

    isAudio: ->
      @mediaType in ['1','4',1,4]

    audioType: ->
      if @mediaType in ['1',1] then 'audio' else 'music'


module.exports =
  TourStop: TourStop
