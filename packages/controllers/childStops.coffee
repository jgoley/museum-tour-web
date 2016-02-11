if Meteor.isClient

  Template.childStops.onCreated ->
    @subscribe 'childStops', @data.id

  Template.childStops.onRendered ->
    parents = Template.instance().data.stops.find({childStops: {$exists: true}}).fetch()
    _.each parents, (parent) ->
      newChildren = _.map parent.childStops, (child, i) ->
        child.parent = parent._id
        TourStops.insert child, (err, id) ->
      TourStops.update({_id: parent._id}, {$set: {childStops : newChildren}})


if Meteor.isServer
  Meteor.publish 'childStops', (stopID) ->
    TourStops.find({'parent': stopID}, {$sort: {order: 1}})
