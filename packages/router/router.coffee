if Meteor.isClient

  BlazeLayout.setRoot 'body'
  FlowRouter.triggers.enter [ -> $('body').attr 'ontouchstart', '' ]
  FlowRouter.triggers.exit [ -> $('.back-btn').blur() ]

  loggedIn = FlowRouter.group
    triggersEnter: [ ->
      unless Meteor.loggingIn() or Meteor.userId()
        route = FlowRouter.current()
        FlowRouter.go 'signIn'
    ]

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

  FlowRouter.route '/signIn',
    name: 'signIn'
    action: () ->
      BlazeLayout.render 'layout',
        content: 'signIn'

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
