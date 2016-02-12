if Meteor.isClient

  Template.tour.onCreated ->
    @tourID = @data.tourID
    @subscribe 'tourStops', @tourID
    @subscribe 'tourDetails', @tourID

    @autorun ->
      tour = Tours.findOne @tourID
      if tour
        family = ''
        if tour.tourType is 1 then family = ' (Family)'
        document.title = tour.mainTitle+': '+tour.subTitle+family

  Template.tour.helpers
    tour: ->
      Tours.findOne Template.instance().tourID

    tourStops: ->
      TourStops.find
        $or: [{type: 'group'},{type: 'single'}]

    isGroup: ->
      @type is "group"

    childStopCount: ->
      @childStops.length

    getTypes: ->
      children = TourStops.find
        _id:
          $in: @childStops
      _.sortBy _.uniq(_.pluck(children.fetch(), 'mediaType')), (type) -> type


if Meteor.isServer

  Meteor.publish 'tourDetails', (tourID) ->
    Tours.find tourID

  Meteor.publish 'tourStops', (tourID) ->
    TourStops.find tour: tourID
