{ Mongo } = require 'meteor/mongo'
{ Class } = require 'meteor/jagi:astronomy'

Tour = new Mongo.Collection 'tours'
Tour = Class.create
  name: 'Tour'
  collection: Tour
  fields:
    tourID   : String
    mainTitle: String
    subTitle : String
    openDate : Date
    closeDate: Date
    baseNum  : Number
    tourType : Number
    menu     : Boolean
    image    : String
    stops    : Object


module.exports =
  Tour: Tour
