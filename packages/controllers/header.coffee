Template.header.helpers
  previousURL: () ->
    Session.get('previousURL')

Template.header.helpers
  history: ->
    window.history.length
  menuOpen: ->
    @menuState.get() is 'open'
  buttonAction: ->
    if @menuState.get() is 'open'
      'menu-close'

Template.header.events
  'touchmove .back-btn': (e) ->
    $(e.target).blur()
  'click .back-btn': (e) ->
    window.history.back()
  'click .sign-out': ->
    Meteor.logout()
  'click .menu-btn': (e, instance) ->
    menuState = instance.data.menuState
    if menuState.get() is 'closed'
      menuState.set 'open'
      $(e.currentTarget).blur()
    else
      menuState.set 'closed'
      $(e.currentTarget).blur()
