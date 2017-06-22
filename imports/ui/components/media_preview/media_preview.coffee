import { ReactiveVar } from 'meteor/reactive-var'
import { deleteFile } from '../../../helpers/files'
import { showNotification } from '../../../helpers/notifications'

import './media_preview.jade'

Template.media_preview.onCreated ->
  @deleting = new ReactiveVar false

Template.media_preview.helpers
  deleting: ->
    Template.instance().deleting.get()

Template.media_preview.events
  'click .delete-media': (event, instance) ->
    deleting = instance.deleting
    deleting.set true
    deleteFile(@media, @tourID, instance.data.object, @typeName)
      .then (error) ->
        deleting.set false
        showNotification error
