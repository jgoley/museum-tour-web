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
    values =
      'mainTitle': form.mainTitle?.value
      'subTitle': form.subTitle?.value
      'openDate': new Date(form.openDate?.value)
      'closeDate': new Date(form.closeDate?.value)
      'baseNum': +form.baseNum?.value
      'tourType': +form.tourType?.value
    if form.image
      fileName = form.image.files[0]?.name
      values.image = fileName

    if not @tour
      Tours().insert values, (e, tourID)->
      if fileName
        uploadFile(form.image.files, tourID, true)
      else
        Router.go '/admin/edit/'+tourID
    else
      tourID = @tour._id
      Tours().update {_id: tourID}, {$set: values}, () ->
      if fileName
        uploadFile(form.image.files, tourID, true, template)
      else
        template.data.editing.set false

  'click .tour-details-cancel': (e, template) ->
    console.log "Cancel"
    template.data.editing.set false

uploadFile = (files, tourID, redirect, template) ->
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
            template.data.editing.set false
