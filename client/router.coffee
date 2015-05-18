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
  path: '/tour/:tourID'
  template: 'tour'
  waitOn: () ->
    [
      Meteor.subscribe "tourStops", @params.tourID
    ]
  data: () ->
    tour: TourStops.findOne({tourID: +@params.tourID})

Router.route 'createTour',
  path: 'create'
  template: 'createTour'

# Router.route 'edit',
#   path: 'edit/:tourID'
#   template: 'editTour'

Router.route 'upload',
  path: 'upload'
  template: 'upload'