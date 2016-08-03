{ Tour } = require '../../../api/tours/index'

require '../views/tours.jade'

Template.editTours.onCreated ->
  @subscribe 'tours'

Template.editTours.helpers
  tours: ->
    Tour.find {}, {sort: openDate: 1, tourType: 1}

  type: ->
    if @tourType is 0
      'adult'
    else if @tourType is 1
      'family'

  isFamily: ->
    @tourType is 1
