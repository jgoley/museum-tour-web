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
    console.log e.target
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

  'click .tour-details-cancel': (e, template) ->
    template.data.editing.set false


