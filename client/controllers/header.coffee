Template.header.helpers
  previousURL: () ->
    Session.get('previousURL')

Template.header.events
  'click .backBtn': ->
    window.history.back()
  'click .sign-out': ->
    Meteor.logout()
  'click .menu-btn': ->
    if Session.get 'offCanvas' then Session.set 'offCanvas', false else Session.set 'offCanvas', true
