Tours = () ->
  @Tap.Collections.Tours

TourStops = () ->
  @Tap.Collections.TourStops

Router.configure
  layoutTemplate: 'layout'

Router.route 'currentTours',
  template: 'currentTours'
  path: '/'
  waitOn: () ->
    [
      Meteor.subscribe 'currentTours'
      Meteor.subscribe 'currentTourStops'
    ]
  data: () ->
    tours: Tours().find()
    stopNumbers: TourStops().find()

Router.route 'archiveTours',
  template: 'archiveTours'
  path: 'archive-tours'
  waitOn: () ->
    [
      Meteor.subscribe 'archiveTours'
    ]
  data: () ->
    tours: Tours().find()

Router.route 'tour',
  path: '/tour/:_id'
  template: 'tour'
  waitOn: () ->
    [
      Meteor.subscribe 'tourStops', @params._id
      Meteor.subscribe 'tours', @params._id
    ]
  data: () ->
    tour: Tours().findOne(@params._id)
    stops: TourStops().find({$and:[{tour: @params._id}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1}})

Router.route 'stop',
  path: '/tour/:tourID/stop/:stopID'
  template: 'stop'
  waitOn: () ->
    [
      Meteor.subscribe 'stop', @params.stopID
      Meteor.subscribe 'childStops', @params.stopID
      Meteor.subscribe 'tourStops', @params.tourID
    ]
  data: () ->
    stop: TourStops().findOne({_id: @params.stopID})
    childStops: TourStops().find({parent: @params.stopID}, {$sort: {order: 1}})
    tourStops: TourStops().find({$and:[{tour: @params.tourID}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1}})

# Router.route 'allStops',
#   waitOn: () ->
#     [
#       Meteor.subscribe 'allStops'
#     ]
#   data: () ->
#     stops: TourStops().find()

Router.route 'convert',
  waitOn: () ->
    [
      Meteor.subscribe 'tours'
    ]
  data: () ->
    tours: Tours().find()

Router.route 'childStops',
  waitOn: () ->
    [
      Meteor.subscribe 'tours'
      Meteor.subscribe 'allStops'
    ]
  data: () ->
    tours: Tours().find()
    stops: TourStops().find()

Router.plugin('ensureSignedIn', {
    only: ['admin', 'editTour', 'editTourDetails', 'createTour']
});

Router.route 'signIn',
  path: '/sign-in'
  template: 'signIn'

Router.route 'admin',
  waitOn: () ->
    [
      Meteor.subscribe 'tours'
    ]
  data: () ->
    tours: Tours().find()

Router.route 'createTour',
  path: 'admin/create'

Router.route 'editTour',
  path: 'admin/edit/:_id/stops'
  waitOn: () ->
    [
      Meteor.subscribe 'tours'
      Meteor.subscribe 'tourStops', @params._id
    ]
  data: () ->
    tour: Tours().findOne(@params._id)
    stops: TourStops().find({$and:[{tour: @params._id}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1}})
    childStops: TourStops().find({$and: [{tour: @params._id}, {type: 'child'}] })

Router.route 'editTourDetails',
  path: 'admin/edit/:_id/details'
  waitOn: () ->
    [
      Meteor.subscribe 'tours'
    ]
  data: () ->
    tour: Tours().findOne(@params._id)
