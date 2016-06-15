{Template} = require 'meteor/templating'
{S3} = require 'meteor/lepozepo:s3'

require './upload_progress.jade'

uploadingFiles = ->
  files = _.filter S3.collection.find().fetch(), (file) ->
    file.status is 'uploading'
  files

Template.uploadProgress.helpers
  files: () ->
    files = uploadingFiles()
    files
