{ Meteor }           = require 'meteor/meteor'
{ Template }         = require 'meteor/templating'
{ Tours }            = require '../../../api/tours/index'
{ S3 }               = require 'meteor/lepozepo:s3'
{ showNotification } = require '../../../helpers/notifications'
{ parsley }          = require 'meteor/amr:parsley.js'
{ $ }                = require 'meteor/jquery'

require '../views/tourDetails.jade'

Template.tourDetails.onRendered ->
  $('.create-tour').parsley
    trigger: 'change'

Template.tourDetails.helpers
  'files': ->
    S3.collection.find()

Template.tourDetails.events
  'submit .edit-tour-details': (e, instance) ->
    e.preventDefault()
    form = e.target
    files = []
    _.each $(form).find("[type='file']"), (file) ->
      if file.files[0] then files.push(file.files[0])
    values =
      'mainTitle': form.mainTitle?.value
      'subTitle': form.subTitle?.value
      'openDate': form.openDate?.value
      'closeDate': form.closeDate?.value
      'baseNum': +form.baseNum?.value
      'tourType': +form.tourType?.value

    if files.length
      if form.image?.files[0]
        values.image = form.image.files[0]?.name.split(" ").join("+")
      if form.thumbnail?.files[0]
        values.thumbnail = form.thumbnail.files[0].name.split(" ").join("+")

    if not @tour
      Tours.insert values, (e, tourID)->
        if files.length
          Meteor.call 'uploadFile', files, tourID, values, true
        else
          Router.go '/admin/edit/'+tourID
    else
      tourID = @tour._id
      if files.length
        Meteor.call 'uploadFile', files, tourID, values, false, instance
      else
        Tours.update {_id: tourID}, {$set: values}, (e) ->
          notify.showNotification(e, '', instance.data.editing)

  'click .tour-details-cancel': (e, instance) ->
    instance.data.editing.set false
