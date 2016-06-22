{ Mongo }            = require 'meteor/mongo'
{ Class }            = require 'meteor/jagi:astronomy'
{ TourStop }         = require '../tour_stops/index'
{ showNotification } = require '../../helpers/notifications'

Tour = new Mongo.Collection 'tours'
Tour = Class.create
  name: 'Tour'
  collection: Tour
  fields:
    baseNum  : Number
    closeDate: Date
    image:
      type: String
      optional: true
    mainTitle: String
    menu     :
      type: Boolean
      optional: true
    openDate : Date
    subTitle : String
    thumbnail: String
    tourType : Number
  methods:
    getParentStops: ->
      TourStop.find {
        $or:
          [
            {type: 'group'},
            {type: 'single'}
          ]
        }, {sort: stopNumber: 1}
    deleteMedia: ->
      tourID = @_id
      image = @image
      thumbnail = @thumbnail
      new Promise (resolve) ->
        if not image and not thumbnail
          resolve()
        if image
          S3.delete "/#{tourID}/#{image}", (error) ->
            if error
              showNotification error
            else if not thumbnail
              resolve()
        if thumbnail
          S3.delete "/#{tourID}/#{thumbnail}", (error) ->
            if error
              showNotification error
            else
              resolve()

    delete: ->
      parentStops = @getParentStops()
      parentStops.forEach (stop) ->
        stop.deleteChildren()
      @remove()

module.exports =
  Tour: Tour
