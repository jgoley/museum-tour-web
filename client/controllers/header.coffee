Template.header.helpers
  previousURL: () ->
    Session.get('previousURL')

Template.header.events
  'click .backBtn': ->
    window.history.back()
  'click .sign-out': ->
    Meteor.logout()
