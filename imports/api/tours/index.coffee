{ Mongo }                = require 'meteor/mongo'
{ Class }                = require 'meteor/jagi:astronomy'
{ TourStop }             = require '../tour_stops/index'
{ showNotification }     = require '../../helpers/notifications'
{ classEvents }          = require '../../helpers/class_helpers'
{ deleteFile }           = require '../../helpers/files'

Tours = new Mongo.Collection 'tours'
Tour = Class.create
  name: 'Tour'
  collection: Tours
  secured: false
  fields:
    baseNum: Number
    closeDate: Date
    image:
      type: String
      optional: true
    mainTitle: String
    menu:
      type: Boolean
      optional: true
    openDate : Date
    subTitle : String
    thumbnail:
      type: String
      optional: true
    tourType : Number

  behaviors:
    timestamp:
      hasCreatedField: true
      createdFieldName: 'createdAt'
      hasUpdatedField: true
      updatedFieldName: 'updatedAt'

  events: classEvents

  helpers:
    getParentStops: (stopToExcludeID='') ->
      TourStop.find
        $and:
          [
            _id: {$ne: stopToExcludeID}
            tour: @_id
            $or:
              [
                {type: 'group'},
                {type: 'single'}
              ]
          ]
        {sort: stopNumber: 1}

    deleteThumbnail: -> deleteFile @thumbnail, @_id, @, 'thumbnail'

    deleteImage: -> deleteFile @image, @_id, @, 'image'

    deleteMedia: ->
      tour = @
      tourID = @_id
      image = @image
      thumbnail = @thumbnail
      new Promise (resolve, reject) ->
        resolve() if not image and not thumbnail
        if image
          tour.deleteImage()
            .then ->
              resolve() unless thumbnail
        if thumbnail
          tour.deleteThumbnail()
            .then (error) ->
              if error then reject(error) else resolve()

    deleteMediaFolder: ->
      new Promise (resolve, reject) =>
        S3.delete "#{@_id}", (error) ->
          if error
            reject error
          else
            resolve()

    delete: ->
      tour = @
      new Promise (resolve, reject) ->
        parentStops = tour.getParentStops()
        parentStops.forEach (stop) ->
          stop.delete()
        tour.deleteMedia()
          .then ->
            tour.deleteMediaFolder()
          .then ->
            tour.remove (error) ->
              if error
                reject error
              else
                resolve()
          .catch reject

module.exports =
  Tour: Tour
