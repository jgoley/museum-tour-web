{ Mongo } = require 'meteor/mongo'
{ Class } = require 'meteor/jagi:astronomy'

Tour = new Mongo.Collection 'tours'
Tour = Class.create
  name: 'Tour'
  collection: Tour
  fields:
    baseNum  : Number
    closeDate: Date
    image:
      type: String
      optional: true
    mainTitle: String
    menu     :
      type: Boolean
      optional: true
    openDate : Date
    subTitle : String
    thumbnail: String
    tourType : Number


module.exports =
  Tour: Tour
