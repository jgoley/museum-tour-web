{ Mongo }                = require 'meteor/mongo'
{ Class }                = require 'meteor/jagi:astronomy'
{ TourStop }             = require '../tour_stops/index'
{ showNotification }     = require '../../helpers/notifications'
{ revertFileNameFormat } = require '../../helpers/class_helpers'

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

  methods:
    getParentStops: (stopeToExcludeID='') ->
      TourStop.find
        $and:
          [
            _id: {$ne: stopeToExcludeID}
            tour: @_id
            $or:
              [
                {type: 'group'},
                {type: 'single'}
              ]
          ]
        {sort: stopNumber: 1}

    deleteMedia: ->
      tourID = @_id
      image = @image
      thumbnail = @thumbnail
      new Promise (resolve, reject) ->
        resolve() if not image and not thumbnail
        if image
          _image = revertFileNameFormat image
          S3.delete "/#{tourID}/#{_image}", (error) ->
            if error
              reject error
            else if not thumbnail
              resolve()
        if thumbnail
          _thumbnail = revertFileNameFormat thumbnail
          S3.delete "/#{tourID}/#{_thumbnail}", (error) ->
            if error
              reject error
            else
              resolve()

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
