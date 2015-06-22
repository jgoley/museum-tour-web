Tours = () ->
  @Tap.Collections.Tours

TourStops = () ->
  @Tap.Collections.TourStops

Router.configure
  layoutTemplate: "base"

Router.route 'home',
  path: '/'
  template: 'tours'
  waitOn: () ->
    [
      Meteor.subscribe "tours"
    ]
  data: () ->
    tours: Tours().find()

Router.route 'tour',
  path: '/tour/:_id'
  template: 'tour'
  waitOn: () ->
    [
      Meteor.subscribe "tourStops", @params._id
      Meteor.subscribe "tours", @params._id
    ]
  data: () ->
    tour: Tours().findOne(@params._id)
    stops: TourStops().find({$and:[{tour: @params._id}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1}})

Router.route 'stop',
  path: '/tour/:tourID/stop/:stopID'
  template: 'stop'
  waitOn: () ->
    [
      Meteor.subscribe "stop", @params.stopID
      Meteor.subscribe "childStops", @params.stopID
    ]
  data: () ->
    stop: TourStops().findOne({_id: @params.stopID})
    childStops: TourStops().find({parent: @params.stopID}, {$sort: {order: 1}})

Router.route 'editStop',
  path: '/tour/:tourID/stop/edit/:stopID'
  template: 'editStop'
  waitOn: () ->
    [
      Meteor.subscribe "stop", @params.stopID
      Meteor.subscribe "tourStops"
    ]
  data: () ->
    stop: TourStops().findOne({_id: @params.stopID})
    stops: TourStops().find()

Router.route 'createTour',
  path: 'create'
  template: 'createTour'

Router.route 'edit',
  path: 'edit'
  template: 'edit'
  waitOn: () ->
    [
      Meteor.subscribe "tours"
    ]
  data: () ->
    tours: Tours().find()

Router.route 'editTour',
  path: 'edit/:_id'
  template: 'editTour'
  waitOn: () ->
    [
      Meteor.subscribe "tours"
      Meteor.subscribe "tourStops", @params._id
    ]
  data: () ->
    tour: Tours().findOne(@params._id)
    stops: TourStops().find({$and:[{tour: @params._id}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1}})

Router.route 'allStops',
  waitOn: () ->
    [
      Meteor.subscribe "allStops"
    ]
  data: () ->
    stops: TourStops().find()

Router.route 'convert',
  waitOn: () ->
    [
      Meteor.subscribe "tours"
    ]
  data: () ->
    tours: Tours().find()

Router.route 'childStops',
  waitOn: () ->
    [
      Meteor.subscribe "tours"
      Meteor.subscribe "allStops"
    ]
  data: () ->
    tours: Tours()
    stops: TourStops()
