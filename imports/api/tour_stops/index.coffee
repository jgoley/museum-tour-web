{ Mongo } = require 'meteor/mongo'
{ Class } = require 'meteor/jagi:astronomy'

TourStops = new Mongo.Collection 'tourStops'

TourStop = Class.create
  name: 'TourStop'
  collection: TourStops
  fields:
    media:
      type: String
      optional: true
    mediaType:
      type: Number
      optional: true
    order:
      type: Number
      optional: true
    parent:
      type: String
      optional: true
    posterImage:
      type: String
      optional: true
    speaker:
      type: String
      optional: true
    stopNumber:
      type: Number
      optional: true
    title: String
    tour: String
    type: String

  methods:
    children: ->
      TourStop.find {parent: @_id}, {sort: {order:1}}

    parent: ->
      TourStop.findOne parent

    isVideo: ->
      @mediaType in ['2',2,'5',5]

    isAudio: ->
      @mediaType in ['1','4',1,4]

    audioType: ->
      if @mediaType in ['1',1] then 'audio' else 'music'

    isGroup: ->
      @type is 'group'

    isSingle:  ->
      @type is 'single'

    isChild: ->
      @parent

    delete: ->
      console.log @
      if @isGroup()
        @deleteChildren()
      @deleteMedia()
        .then =>
          @remove()

    deleteChildren: ->
      @children().forEach (child) ->
        child.delete()

    deleteMedia: ->
      S3.delete "/#{@tour}/#{@media}", (error) =>
        if error
          showNotification error
        else
          if @posterImage
            S3.delete "/#{@tour}/#{@posterImage}"
          @set 'posterImage', null
          @set 'media', null
          @set 'mediaType', 1
          @save()

module.exports =
  TourStop : TourStop
  TourStops: TourStops
