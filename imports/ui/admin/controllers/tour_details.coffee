{ Tour }             = require '../../../api/tours/index'
{ showNotification } = require '../../../helpers/notifications'
parsley              = require 'parsleyjs'
{ $ }                = require 'meteor/jquery'
{ ReactiveVar }      = require 'meteor/reactive-var'
{ formatFileName,
  formFiles,
  uploadFiles,
  finishTourSave }   = require '../../../helpers/edit'

require '../views/tour_details.jade'

Template.tourDetails.onCreated ->
  @uploading = new ReactiveVar false

Template.tourDetails.onRendered ->
  $('.create-tour').parsley
    trigger: 'change'

Template.tourDetails.helpers
  uploading: ->
    Template.instance().uploading.get()

Template.tourDetails.events
  'submit .edit-tour-details': (e, instance) ->
    e.preventDefault()

    form  = e.target
    files = formFiles instance.$(form)
    props =
      'mainTitle': form.mainTitle?.value
      'subTitle' : form.subTitle?.value
      'openDate' : new Date form.openDate?.value
      'closeDate': new Date form.closeDate?.value
      'baseNum'  : +form.baseNum?.value
      'tourType' : +form.tourType?.value

    if form.image?.files[0]
      props.image = formatFileName form.image
    if form.thumbnail?.files[0]
      props.thumbnail = formatFileName form.thumbnail

    tourID = @tour?._id
    tour = @tour or new Tour()
    isNew = tour._isNew
    tour.set props
    tour.save (error, id) ->
      tourID = if isNew then id else tourID
      if error
        showNotification error
        return
      if files.length
        uploadFiles(files, tourID, instance.uploading)
          .then ->
            finishTourSave tourID, isNew
      else
        finishTourSave tour, isNew

  'click .tour-details-cancel': (e, instance) ->
    instance.data.editing.set false
