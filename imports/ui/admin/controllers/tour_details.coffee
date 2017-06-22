import { Tour } from '../../../api/tours/index'
import { showNotification } from '../../../helpers/notifications'
import { ReactiveVar } from 'meteor/reactive-var'
import moment from 'moment'
import { go } from '../../../helpers/route_helpers'
import { formatFileName,
         formFiles,
         uploadFiles } from '../../../helpers/files'
import { parsley } from '../../../helpers/edit'

import '../views/tour_details.jade'

finishTourSave = (tourID, isNew) ->
  if isNew
    go '/tour/edit/'+tourID
  else
    showNotification()

formatDate = (date) ->
  moment(date).format 'YYYY-MM-DD'

Template.tourDetails.onRendered ->
  parsley '.edit-tour-details'

Template.tourDetails.helpers
  openDate: ->
    openDate = @tour?.openDate
    if openDate
      formatDate openDate

  closeDate: ->
    closeDate = @tour?.closeDate
    if closeDate
      formatDate closeDate

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
      uploadFiles(files, tourID)
        .then ->
          finishTourSave tourID, isNew

  'click .tour-details-cancel': (e, instance) ->
    instance.data.editing.set false
