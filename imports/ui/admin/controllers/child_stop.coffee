require '../views/child_stop.jade'

Template.childStop.onCreated ->
  @edit = ReactiveVar false

Template.childStop.helpers
  parent: ->
    TourStops.findOne Template.instance().data.child.parent
  edit: ->
    Template.instance().edit.get()

Template.childStop.events
  'click .child-title': (event, instance) ->
    instance.edit.set not instance.edit.get()
