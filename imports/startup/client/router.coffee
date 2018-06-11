import '../../ui/layout.coffee'
import '../../ui/menu/index'
import '../../ui/tours/index'
import '../../ui/stops/index'
import '../../ui/admin/index'
import '../../ui/help/help.coffee'
import '../../ui/feedback.coffee'

import '../../ui/components/loading/loading.jade'


BlazeLayout.setRoot 'body'
FlowRouter.triggers.enter [ -> $('body').animate(scrollTop: 0, 0) ]
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

loggedIn.route '/help-video',
  name: 'helpVideo'
  action: (params) ->
    BlazeLayout.render 'layout',
      content: 'helpVideo'

module.exports =
  FlowRouter: FlowRouter
