import { Tour } from '../../../api/tours/index'
import { TourStop } from '../../../api/tour_stops/index'
import { analytics } from 'meteor/okgrow:analytics'

import '../views/currentTours.jade'
import '../../components/thumbnail/thumbnail.coffee'
import '../../components/stop_search/stop_search.coffee'

Template.currentTours.onCreated ->
  @subscribe 'currentTours'
  @subscribe 'currentTourStops'
  title = 'Current Tours'
  document.title = title
  analytics.page(title)

Template.currentTours.helpers
  tours: ->
    Tour.find()

  stops: ->
    TourStop.find()
