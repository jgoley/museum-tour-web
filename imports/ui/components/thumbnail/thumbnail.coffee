require './thumbnail.jade'

Template.thumbnail.helpers
  type: ->
    if @tour.tourType is 0
      'adult'
    else if @tour.tourType is 1
      'family'
