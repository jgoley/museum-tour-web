import { ReactiveVar } from 'meteor/reactive-var'

import './file_upload.jade'

Template.fileUpload.onCreated ->
  @fileName = new ReactiveVar('No file selected')
  @hasFile = new ReactiveVar(false)

Template.fileUpload.helpers
  fileName: ->
    Template.instance().fileName.get()
  hasFile: ->
    if Template.instance().hasFile.get()
      'has-file'

Template.fileUpload.events
  'change .btn-file': (event, instance) ->
    instance.fileName.set(event.target.value.replace('C:\\fakepath\\',''))
    instance.hasFile.set(true)
  'click .remove': (event, instance) ->
    instance.hasFile.set(false)
    instance.fileName.set('No file selected')
    $('input[type=file]').val('')
