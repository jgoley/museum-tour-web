Template.tour.helpers
  group: () ->
    console.log "Group?",@group
    if @group is "group"
      types = _.chain(@childStops)
        .map((stop) -> stop.type)
        .uniq()
        .value()
      console.log types
      types