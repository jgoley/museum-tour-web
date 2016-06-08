{ Template } = require 'meteor/templating'
{ moment }   = require 'meteor/momentjs:moment'
{ Tours }    = require '../../../api/tours/index'

require '../views/archivedTours.jade'
require '../../components/thumbnail/thumbnail'

Template.archivedTours.onCreated ->
  @subscribe 'archivedTours'
  document.title = 'Archived Tours'

Template.archivedTours.helpers
  tours: ->
    Tours.find()

  formatDate: (date) ->
    moment(date).format('MMMM D, YYYY')
