Template.upload.events
  'submit .upload': (e) ->
    e.preventDefault()
    console.log "uploading"
    files = $("input[type=file]")
    # console.log $("input[type=file]")[0].files
    _.each files, (file) ->
      console.log file.files
      files = file.files
      S3.upload
        files:files
        unique_name: false
        path: 'media'
        (e,r) ->
          console.log(e,r)

Template.upload.helpers
  "files": () ->
    S3.collection.find()
  "progress": () ->
    Math.round this.uploader.progress() * 100