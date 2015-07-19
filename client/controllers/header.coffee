Template.header.helpers
  previousURL: () ->
    Session.get('previousURL')
Template.header.events
  'click .backBtn': ->
    window.history.back()
