require '../views/header.jade'

Template.header.onCreated ->
  @menuState = new ReactiveVar false

Template.header.helpers
  menuState: ->
    Template.instance().menuState

  previousURL: ->
    Session.get('previousURL')

  history: ->
    window.history.length

  menuOpen: ->
    Template.instance().menuState.get()

  buttonAction: ->
    if Template.instance().menuState.get()
      'menu-close'

Template.header.events
  'touchmove .back-btn': (event) ->
    $(event.target).blur()

  'click .back-btn': ->
    window.history.back()

  'click .sign-out': ->
    Meteor.logout()

  'click .menu-btn': (event, instance) ->
    menuState = instance.menuState
    menuState.set not menuState.get()
    console.log menuState
    $(event.currentTarget).blur()
