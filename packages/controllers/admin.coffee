if Meteor.isClient

  Template.admin.helpers
    type: ->
      if @tourType is 0
        'adult'
      else if @tourType is 1
        'family'
    isFamily: ->
      @tourType is 1

  Template.admin.events
    'click .delete-tour': (e, template) ->
      Meteor.call 'deleteTour', @_id, (error, result) ->

Meteor.methods
  deleteTour: (id) ->
    Tours.remove({_id: id})

