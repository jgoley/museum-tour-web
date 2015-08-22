Template.header.helpers
  previousURL: () ->
    Session.get('previousURL')

Template.header.helpers
  history: ->
    window.history.length

Template.header.events
  'click .back-btn': ->
    window.history.back()
  'click .sign-out': ->
    Meteor.logout()
  'click .menu-btn': (e) ->
    if Session.get 'offCanvas'
      Session.set 'offCanvas', false
      $(e.currentTarget).blur()
      $(e.currentTarget).toggleClass('menu-close')
    else
      Session.set 'offCanvas', true
      $(e.currentTarget).toggleClass('menu-close')
