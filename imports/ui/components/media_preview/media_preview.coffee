import { ReactiveVar } from 'meteor/reactive-var'
import { deleteFile } from '../../../helpers/files'
import { showNotification } from '../../../helpers/notifications'

import './media_preview.jade'

Template.media_preview.onCreated ->
  @deleting = new ReactiveVar false
  console.log @data

Template.media_preview.helpers
  deleting: ->
    Template.instance().deleting.get()
  stopTourPath: ->
    tourID = Template.instance().data.tourID
    if tourID then "#{tourID}/" else ''

Template.media_preview.events
  'click .delete-media': (event, instance) ->
    deleting = instance.deleting
    instanceData = instance.data
    deleting.set(true)
    if instanceData.asset
      instanceData.asset.delete().then ->
        deleting.set(false)
        showNotification()
    else
      deleteFile(@media, @tourID, instance.data.object, @typeName)
        .then (error) ->
          deleting.set false
          showNotification error
