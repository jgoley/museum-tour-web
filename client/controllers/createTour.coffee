Tours = ()->
  @Tap.Collections.Tours

uploadFiles = (files) ->


Template.createTour.helpers
  'files': ->
    S3.collection.find()

Template.createTour.events
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

Template.editTour.helpers
  "getID": () ->
    @_id
  "currentStops" : () ->
    console.log @tour._id
    console.log TourStops().findOne({'tour': @tour._id})
    TourStops.findOne({'tour': @tour._id})
  'tour': ->
    Tours()
