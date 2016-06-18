{ moment }   = require 'momentjs'
{ Tour }    = require '../../../api/tours/index'

require '../views/archivedTours.jade'
require '../../components/thumbnail/thumbnail'

Template.archivedTours.onCreated ->
  @subscribe 'archivedTour'
  document.title = 'Archived Tour'

Template.archivedTours.helpers
  tours: ->
    Tour.find()

  formatDate: (date) ->
    moment(date).format('MMMM D, YYYY')
