import { Tour } from '../../../api/tours/index'
import moment from 'moment'
import { analytics } from 'meteor/okgrow:analytics'

import '../views/archivedTours.jade'
import '../../components/thumbnail/thumbnail.coffee'

Template.archivedTours.onCreated ->
  @subscribe 'archivedTour'
  title = 'Archived Tours'
  document.title = title
  analytics.page(title)

Template.archivedTours.helpers
  tours: ->
    Tour.find {}, sort: closeDate: -1
  sinceShow: ->
    moment(@closeDate).fromNow()
