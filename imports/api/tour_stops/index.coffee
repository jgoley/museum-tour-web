import { Mongo } from 'meteor/mongo'
import { Class } from 'meteor/jagi:astronomy'
import { showNotification} from '../../helpers/notifications'
import { classEvents } from '../../helpers/class_helpers'
import { formatFileName } from '../../helpers/files'

TourStops = new Mongo.Collection 'tourStops'

TourStop = Class.create
  name: 'TourStop'
  collection: TourStops
  secured: false
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

  behaviors:
    timestamp:
      hasCreatedField: true
      createdFieldName: 'createdAt'
      hasUpdatedField: true
      updatedFieldName: 'updatedAt'

  events: classEvents

  helpers:
    children: ->
      TourStop.find {parent: @_id}, {sort: {order:1}}

    parent: ->
      TourStop.findOne parent

    getAdjacentStops: ->
      TourStop.find
        $and:[
          {tour: @tour}
          {$or: [{stopNumber: @stopNumber + 1}, {stopNumber: @stopNumber - 1}]}
        ]

    isVideo: ->
      @mediaType in [ '2',2,'5',5 ]

    isAudio: ->
      @mediaType in [ '1','4',1,4 ]

    isImage: ->
      @mediaType in [ '3',3 ]

    audioType: ->
      if @mediaType in ['1',1] then 'audio' else 'music'

    isGroup: ->
      @type is 'group'

    isSingle:  ->
      @type is 'single'

    isChild: ->
      @parent

    delete: ->
      stop = @
      new Promise (resolve) ->
        if stop.isGroup()
          stop.deleteChildren()
            .then -> stop.remove resolve
        else
          stop.deleteMedia(false)
            .then -> stop.remove resolve

    deleteChildren: ->
      children = @children()
      childCount = children.count()
      new Promise (resolve) ->
        if childCount
          deletions = _.map children.fetch(), (child) ->
            new Promise (cont) -> child.delete().then -> cont()
          Promise.all(deletions).then -> resolve()
        else
          resolve()

    deleteMedia: (save=true) ->
      stop = @
      new Promise (resolve) ->
        media = stop.media
        resolve() unless media
        _media = formatFileName media, true
        S3.delete "/#{stop.tour}/#{_media}", (error, res) ->
          if error
            showNotification error
          else
            poster = stop.posterImage
            if poster
              posterFileName = formatFileName poster, true
              S3.delete "/#{stop.tour}/#{posterFileName}"
            if save
              stop.set 'posterImage', null
              stop.set 'media', null
              stop.set 'mediaType', 1
              stop.save resolve
            else
              resolve()

module.exports =
  TourStop : TourStop
  TourStops: TourStops
