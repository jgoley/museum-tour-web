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
      @find parent: @_id


module.exports =
  TourStop: TourStop
