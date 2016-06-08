{Meteor} = require 'meteor/meteor'
{Template} = require 'meteor/templating'

require './upload.jade'

Template.upload.events
  'submit .upload': (e) ->
    e.preventDefault()
    files = $("input[type=file]")
    _.each files, (file) ->
      files = file.files
      Meteor.call 'upload', files, (error, response) ->
        if error
          throw new Meteor.error error

Template.upload.helpers
  "files": () ->
    S3.collection.find()
  "progress": () ->
    Math.round this.uploader.progress() * 100
