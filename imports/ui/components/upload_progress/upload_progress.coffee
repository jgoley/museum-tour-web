import './upload_progress.jade'

uploadingFiles = ->
  files = _.filter S3.collection.find().fetch(), (file) ->
    file.status is 'uploading'
  files

Template.upload_progress.helpers
  files: () ->
    files = uploadingFiles()
    files
