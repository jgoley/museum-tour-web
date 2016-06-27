{ Tour } = require '../../../api/tours/index'
moment   = require 'moment'

require '../views/archivedTours.jade'
require '../../components/thumbnail/thumbnail'

Template.archivedTours.onCreated ->
  @subscribe 'archivedTour'
  document.title = 'Archived Tour'

Template.archivedTours.helpers
  tours: ->
    Tour.find()
  sinceShow: ->
    moment(@closeDate).fromNow()
