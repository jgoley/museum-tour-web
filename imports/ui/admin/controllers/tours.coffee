import { Tour } from '../../../api/tours/index'
import { ReactiveVar } from 'meteor/reactive-var'

import '../views/tours.jade'

Template.editTours.onCreated ->
  @subscribe 'tours'
  @query = new ReactiveVar('')

  @addTitleQuery = (query) =>
    searchQuery = @query.get()
    titleQuery = {}
    if searchQuery
      titleQuery.$or = [
        {mainTitle: new RegExp(searchQuery, 'i')}
        {subTitle: new RegExp(searchQuery, 'i')}
      ]
    _.extend(query, titleQuery)


Template.editTours.helpers
  currentTours: ->
    today = new Date()
    query =
      $and: [
        {
          openDate:
            $lte: today
        }
        {
          closeDate:
            $gte: today
        }
      ]

    Tour.find Template.instance().addTitleQuery(query),
      sort: openDate: -1, tourType: 1

  futureTours: ->
    query =
      $and: [
        {
          openDate:
            $gt: new Date()
        }
      ]

    Tour.find Template.instance().addTitleQuery(query),
      sort: openDate: -1, tourType: 1

  archivedTours: ->
    query =
      closeDate:
        $lte: new Date()

    Tour.find Template.instance().addTitleQuery(query),
      sort: closeDate: -1, tourType: 1

  type: ->
    if @tourType is 0
      'adult'
    else if @tourType is 1
      'family'

  isFamily: ->
    @tourType is 1

Template.editTours.events
  'keyup .tour-search': (event, instance) ->
    instance.query.set(event.target.value)
