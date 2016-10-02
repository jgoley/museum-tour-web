{ TourStop } = require '../api/tour_stops/index'

updateSortOrder = (event, instance, property, baseNum=0, parentStopId=null) ->
  id = instance.$(event.item).data 'id'
  oldOrder = ++event.oldIndex + baseNum
  newOrder = ++event.newIndex + baseNum
  movedTourStop = TourStop.findOne id
  movingUp = movedTourStop[property] > newOrder
  query = []

  query.push _id: $ne: movedTourStop._id

  if movingUp
    query.push "#{property}": $gte: newOrder
    query.push "#{property}": $lte: oldOrder
  else
    query.push "#{property}": $lte: newOrder
    query.push "#{property}": $gt: oldOrder

  if parentStopId
    query.push parent: parentStopId

  TourStop.find({$and: query}, {sort: "#{property}": 1}).forEach (stop) ->
    amount = if movingUp then 1 else -1
    stop[property] = stop[property] + amount
    stop.save()

  movedTourStop[property] = newOrder
  movedTourStop.save()


module.exports =
  updateSortOrder: updateSortOrder
