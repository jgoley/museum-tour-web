{ TourStop } = require '../api/tour_stops/index'

updateSortOrder = (indices, stop, deleting=false) ->

  unless _.isObject(stop)
    stop = TourStop.findOne stop

  parent = stop.parent
  property = if parent then 'order' else 'stopNumber'
  oldOrder = stop[property]

  query = []
  query.push tour: stop.tour

  if deleting
    query.push "#{property}": $gte: oldOrder
    movingUp = false

  else
    baseNum = oldOrder - ++indices[0]
    query.push _id: $ne: stop._id
    newOrder = ++indices[1] + baseNum
    movingUp = stop[property] > newOrder

    if movingUp
      query.push "#{property}": $gte: newOrder
      query.push "#{property}": $lte: oldOrder
    else
      query.push "#{property}": $lte: newOrder
      query.push "#{property}": $gt: oldOrder

    if parent
      query.push parent: parent

  TourStop.find({$and: query}, {sort: "#{property}": 1})
    .forEach (adjacentStop) ->
      amount = if movingUp then 1 else -1
      adjacentStop[property] = adjacentStop[property] + amount
      console.log adjacentStop
      adjacentStop.save()

  unless deleting
    stop[property] = newOrder
    stop.save()


module.exports =
  updateSortOrder: updateSortOrder
