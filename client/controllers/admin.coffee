Tours = () ->
  @Tap.Collections.Tours

Template.admin.helpers
  type: ->
    if @tourType is 0
      'adult'
    else if @tourType is 1
      'family'

Template.admin.events
  'click .delete-tour': (e, template) ->
    Tours().remove({_id: @_id})
