require '../views/child_stops.jade'

Template.childStops.helpers
  addChild: ->
    Session.get('add-child-'+@stop._id)
