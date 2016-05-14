if Meteor.isClient

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

Meteor.methods
  upload: (files) ->
    S3.upload
      files:files
      unique_name: false
      path: 'media'
      (e,r) ->
        console.log(e,r)
