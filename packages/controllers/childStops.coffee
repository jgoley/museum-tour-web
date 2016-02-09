TourStops = () ->
  @Tap.Collections.TourStops
Tours = () ->
  @Tap.Collections.Tours

Template.childStops.rendered = () ->
  parents = Template.instance().data.stops.find({childStops: {$exists: true}}).fetch()
  _.each parents, (parent) ->
    newChildren = _.map parent.childStops, (child, i) ->
      child.parent = parent._id
      TourStops().insert child, (err, id) ->
    TourStops().update({_id: parent._id}, {$set: {childStops : newChildren}})
