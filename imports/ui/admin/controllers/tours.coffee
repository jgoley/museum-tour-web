{ Tours }    = require '../../../api/tours/index'

require '../views/tours.jade'

Template.editTours.onCreated ->
  @subscribe 'tours'

Template.editTours.helpers
  tours: ->
    Tours.find {}, {sort: openDate: 1, tourType: 1}

  type: ->
    if @tourType is 0
      'adult'
    else if @tourType is 1
      'family'

  isFamily: ->
    @tourType is 1

Template.editTours.events
  'click .delete-tour': (e, template) ->
    Meteor.call 'deleteTour', @_id, (error, result) ->
      if error
        throw new Meteor.Error error.reason
