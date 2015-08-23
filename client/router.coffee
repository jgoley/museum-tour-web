Tours = () ->
  @Tap.Collections.Tours

TourStops = () ->
  @Tap.Collections.TourStops

Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  trackPageView: true

adminHook = () ->
  if not Meteor.userId()
    @redirect '/sign-in'
  else
    @next()

Router.onBeforeAction adminHook,
  only: ['admin']

Router.onBeforeAction () ->
  $('body').attr('ontouchstart', '')
  @next()

Router.onAfterAction () ->
  $('.back-btn').blur()

Router.route 'currentTours',
  template: 'currentTours'
  path: '/'
  waitOn: () ->
    [
      Meteor.subscribe 'currentTours'
      Meteor.subscribe 'currentTourStops'
    ]
  data: () ->
    tours: Tours().find({}, sort: {startDate: 1, tourType: 1})
    stopNumbers: TourStops().find()

Router.route 'archivedTours',
  template: 'archivedTours'
  path: 'archived-tours'
  waitOn: () ->
    [
      Meteor.subscribe 'archivedTours'
    ]
  data: () ->
    tours: Tours().find()

Router.route 'tour',
  path: '/tour/:_id'
  template: 'tour'
  waitOn: () ->
    [
      Meteor.subscribe 'tourStops', @params._id
      Meteor.subscribe 'tourDetails', @params._id
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
    childStops: TourStops().find({parent: @params.stopID}, {sort: {order: 1}})
    tourStops: TourStops().find({$and:[{tour: @params.tourID}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1, 'order': 1}})

Router.route 'help'
Router.route 'feedback'

Router.route 'allStops',
  waitOn: () ->
    [
      Meteor.subscribe 'allStops'
    ]
  data: () ->
    stops: TourStops().find()

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
    tours: Tours()
    stops: TourStops()

Router.plugin('ensureSignedIn', {
    only: ['admin', 'editTour', 'tourDetails', 'createTour']
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

    tours: Tours().find({}, {sort: openDate: -1, tourType: 1})

Router.route 'createTour',
  path: 'admin/create'
  template: 'tourDetails'

Router.route 'editTour',
  path: 'admin/edit/:_id'
  waitOn: () ->
    [
      Meteor.subscribe 'tourDetails', @params._id
      Meteor.subscribe 'tourStops', @params._id
    ]
  data: () ->
    tour: Tours().findOne(@params._id)
    stops: TourStops().find({$and:[{tour: @params._id}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1}})
    childStops: TourStops().find({$and: [{tour: @params._id}, {type: 'child'}] })
