Tours = ()->
  @Tap.Collections.Tours

Template.tourDetails.onRendered ->
  $('.create-tour').parsley
    trigger: 'change'


Template.tourDetails.helpers
  'files': ->
    S3.collection.find()

Template.tourDetails.events
  'submit .edit-tour-details': (e, template) ->
    e.preventDefault()
    form = e.target
    files = []
    _.each $(form).find("[type='file']"), (file) ->
      if file.files[0] then files.push(file.files[0])
    values =
      'mainTitle': form.mainTitle?.value
      'subTitle': form.subTitle?.value
      'openDate': new Date(form.openDate?.value)
      'closeDate': new Date(form.closeDate?.value)
      'baseNum': +form.baseNum?.value
      'tourType': +form.tourType?.value

    if files.length
      if form.image?.files[0]
        values.image = form.image.files[0]?.name.split(" ").join("+")
      if form.thumbnail?.files[0]
        values.thumbnail = form.thumbnail.files[0].name.split(" ").join("+")

    if not @tour
      Tours().insert values, (e, tourID)->
        if files.length
          uploadFile(files, tourID, values, true)
        else
          Router.go '/admin/edit/'+tourID
    else
      tourID = @tour._id
      if files.length
        uploadFile(files, tourID, values, false, template)
      else
        Tours().update {_id: tourID}, {$set: values}, () ->
          template.data.editing.set false

  'click .tour-details-cancel': (e, template) ->
    console.log "Cancel"
    template.data.editing.set false

uploadFile = (files, tourID, values, redirect, template) ->
  if files.length > 0
    S3.upload
      files:files
      unique_name: false
      path: tourID
      (e,r) ->
        console.log e,r
        if e
          alert("Something went wrong with the upload. Are you connected to the interwebs?")
        else
          if redirect
            Router.go '/admin/edit/'+tourID
          else
            console.log 'updateing', values
            Tours().update {_id: tourID}, {$set: values}
