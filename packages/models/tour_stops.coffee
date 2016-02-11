TourStops = new Mongo.Collection 'tourStops'
TourStop = Astro.Class
  name: 'TourStop'
  collection: TourStops
  fields:
    tour: 'string'
    type: 'string'
    title: 'string'
    stopNumber: 'number'
    speaker: 'string'
    media: 'string'
    mediaType: 'number'
    parent: 'string'
    order: 'number'
    childStops: 'array'



