import { analytics } from 'meteor/okgrow:analytics'
import '../views/header.jade'

Template.header.onCreated ->
  @menuState = @data.menuState

Template.header.helpers
  menuState: ->
    Template.instance().menuState

  previousURL: ->
    Session.get 'previousURL'

  history: ->
    window.history.length

  menuOpen: ->
    Template.instance().menuState.get()

  buttonAction: ->
    if Template.instance().menuState.get()
      'menu-close'

Template.header.events
  'click a': (event) ->
    $(event.target).blur()
    analytics.track 'Menu',
      eventName: event.target.innerText

  'click .back-btn': ->
    window.history.back()

  'click .sign-out': ->
    Meteor.logout ->
      FlowRouter.go '/login'

  'click .menu-btn': (event, instance) ->
    menuState = instance.menuState
    menuState.set not menuState.get()
    analytics.track 'Menu',
      eventName: 'Open/Close'

  'click .content-curtain' : (event, instance) ->
    instance.menuState.set false
