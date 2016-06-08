{ Mongo } = require 'meteor/mongo'
{ Class } = require 'meteor/jagi:astronomy'

Tours = new Mongo.Collection 'tours'
Tour = Class.create
  name: 'Tour'
  collection: Tours
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
  Tours: Tours
