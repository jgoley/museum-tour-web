
uploadingFiles = ->
  files = _.filter S3.collection.find().fetch(), (file) ->
    file.status is 'uploading'
  files

Template.uploadProgress.helpers
  files: () ->
    files = uploadingFiles()
    files
