TourStops = new Mongo.Collection 'tourStops'
TourStop = Astro.Class
  name: 'TourStop'
  collection: TourStops
  fields:
    tour: 'string'
    parent: 'string'
    type: 'string'
    title: 'string'
    stopNumber: 'number'
    speaker: 'string'
    media: 'string'
    mediaType: 'number'
    order: 'number'

  methods:
    children: ->
      TourStops.find parent: @_id

