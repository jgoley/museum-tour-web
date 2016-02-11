Tours = new Mongo.Collection 'tours'
Tour = Astro.Class
  name: 'Tour'
  collection: Tours
  fields:
    tourID: 'number'
    mainTitle: 'string'
    subTitle: 'string'
    openDate: 'date'
    closeDate: 'date'
    baseNum: 'number'
    tourType: 'number'
    menu: 'boolean'
    image: 'string'
    stops: 'array'


