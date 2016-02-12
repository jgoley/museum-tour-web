if Meteor.isClient

  BlazeLayout.setRoot 'body'

  loggedIn = FlowRouter.group
    triggersEnter: [ ->
      unless Meteor.loggingIn() or Meteor.userId()
        route = FlowRouter.current()
        FlowRouter.go 'login'
    ]

  # Router.onBeforeAction () ->
  #   $('body').attr('ontouchstart', '')
  #   @next()

  # Router.onAfterAction () ->
  #   $('.back-btn').blur()


  FlowRouter.route '/',
    name: 'currentTours'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'currentTours'

  FlowRouter.route '/archivedTours',
    name: 'archivedTours'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'archivedTours'

  FlowRouter.route '/tour/:_id',
    name: 'tour'
    action: (params) ->
      BlazeLayout.render 'layout',
        content: 'tour'
        data:
          tourID: params._id

  FlowRouter.route '/tour/:tourID/stop/:stopID',
    name: 'stop'
    action: (params) ->
      BlazeLayout.render 'layout',
        content: 'stop'
        data:
          tourID: params.tourID
          stopID: params.stopID


  # Router.route 'stop',
  #   path: '/tour/:tourID/stop/:stopID'
  #   template: 'stop'
  #   waitOn: () ->
  #     [
  #       Meteor.subscribe 'stop', @params.stopID
  #       Meteor.subscribe 'childStops', @params.stopID
  #       Meteor.subscribe 'tourStops', @params.tourID
  #     ]
  #   data: () ->
  #     stop: TourStops().findOne({_id: @params.stopID})
  #     childStops: TourStops().find({parent: @params.stopID}, {sort: {order: 1}})
  #     tourStops: TourStops().find({$and:[{tour: @params.tourID}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1, 'order': 1}})

  FlowRouter.route '/help',
    name: 'help'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'help'

  FlowRouter.route '/feedback',
    name: 'feedback'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'feedback'


  # Router.route 'help'
  # Router.route 'feedback'

  # Router.route 'allStops',
  #   waitOn: () ->
  #     [
  #       Meteor.subscribe 'allStops'
  #     ]
  #   data: () ->
  #     stops: TourStops().find()

  # Router.route 'convert',
  #   waitOn: () ->
  #     [
  #       Meteor.subscribe 'tours'
  #     ]
  #   data: () ->
  #     tours: Tours().find()

  # Router.route 'childStops',
  #   waitOn: () ->
  #     [
  #       Meteor.subscribe 'tours'
  #       Meteor.subscribe 'allStops'
  #     ]
  #   data: () ->
  #     tours: Tours()
  #     stops: TourStops()

  # Router.plugin('ensureSignedIn', {
  #     only: ['admin', 'editTour', 'tourDetails', 'createTour']
  # });

  FlowRouter.route '/signIn',
    name: 'signIn'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'signIn'

  # Router.route 'signIn',
  #   path: '/sign-in'
  #   template: 'signIn'

  loggedIn.route '/admin',
    name: 'admin'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'admin'


  # Router.route 'admin',
  #   waitOn: () ->
  #     [
  #       Meteor.subscribe 'tours'
  #     ]
  #   data: () ->

  #     tours: Tours().find({}, {sort: openDate: -1, tourType: 1})

  loggedIn.route '/createTour',
    name: 'createTour'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'help'

  # Router.route 'createTour',
  #   path: 'admin/create'
  #   template: 'tourDetails'


  loggedIn.route '/editTour',
    name: 'editTour'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'editTour'

  # Router.route 'editTour',
  #   path: 'admin/edit/:_id'
  #   waitOn: () ->
  #     [
  #       Meteor.subscribe 'tourDetails', @params._id
  #       Meteor.subscribe 'tourStops', @params._id
  #     ]
  #   data: () ->
  #     tour: Tours().findOne(@params._id)
  #     stops: TourStops().find({$and:[{tour: @params._id}, {$or: [{type: 'single'}, {type: 'group'}]}]}, {sort: {'stopNumber': 1}})
  #     childStops: TourStops().find({$and: [{tour: @params._id}, {type: 'child'}] })
