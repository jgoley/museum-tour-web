Tours = ()->
  @Tap.Collections.Tours

uploadFiles = (files) ->

Template.tourDetails.onRendered ->
  $('.create-tour').parsley
    trigger: 'change'


Template.tourDetails.helpers
  'files': ->
    S3.collection.find()

Template.tourDetails.events
  'submit .create-tour': (e, template) ->
    e.preventDefault()
    form = e.target
    fileName = form.image.files[0]?.name
    values =
      'mainTitle': form.mainTitle?.value
      'subTitle': form.subTitle?.value
      'openDate': new Date(form.openDate?.value)
      'closeDate': new Date(form.closeDate?.value)
      'baseNum': +form.baseNum?.value
      'tourType': +form.tourType?.value
      'image': fileName

    Tours().insert values, (e, tourID)->
      if fileName
        files = form.image.files
        if files.length > 0
          S3.upload
            files:files
            unique_name: false
            path: tourID
            (e,r) ->
              Router.go '/admin/edit/'+tourID
      else
        Router.go '/admin/edit/'+tourID

