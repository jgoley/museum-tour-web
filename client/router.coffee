getCollections = () -> 
  @collections

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
    tours: Tours.find()

Router.route 'tour',
  path: '/tour/:_id'
  template: 'tour'
  waitOn: () ->
    [
      Meteor.subscribe "tourStops", @params._id
    ]
  data: () ->
    tour: TourStops.findOne(@params._id)

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
    tours: Tours.find()

Router.route 'editTours',
  path: 'edit/:_id'
  template: 'editTours'
  waitOn: () ->
    [
      Meteor.subscribe "tours"
    ]
  data: () ->
    tours: Tours.findOne(@params._id)


# Router.route 'edit',
#   path: 'edit/:tourID'
#   template: 'editTour'

Router.route 'upload',
  path: 'upload'
  template: 'upload'