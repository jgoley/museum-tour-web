require '../../ui/layout'
require '../../ui/menu/index'
require '../../ui/tours/index'
require '../../ui/stops/index'
require '../../ui/admin/index'
require '../../ui/help/help.coffee'

BlazeLayout.setRoot 'body'
FlowRouter.triggers.enter [ -> $('body').attr 'ontouchstart', '' ]
FlowRouter.triggers.exit [ -> $('.back-btn').blur() ]

loggedIn = FlowRouter.group
  triggersEnter: [ ->
    unless Meteor.loggingIn() or Meteor.userId()
      route = FlowRouter.current()
      FlowRouter.redirect '/login'
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

FlowRouter.route '/login',
  name: 'login'
  action: () ->
    BlazeLayout.render 'layout',
      content: 'login'

loggedIn.route '/signIn',
  triggersEnter: [ -> FlowRouter.redirect '/login' ]

loggedIn.route '/admin',
  triggersEnter: [ -> FlowRouter.redirect '/tours/edit' ]

loggedIn.route '/tours/edit',
  name: 'editTours'
  action: () ->
    BlazeLayout.render 'layout',
      content: 'editTours'

loggedIn.route '/tours/create',
  name: 'createTour'
  action: () ->
    BlazeLayout.render 'layout',
      content: 'tourDetails'

loggedIn.route '/tour/edit/:tourID',
  name: 'editTour'
  action: (params) ->
    BlazeLayout.render 'layout',
      content: 'editTour'
      data:
        tourID: params.tourID

module.exports =
  FlowRouter: FlowRouter
