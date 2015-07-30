Template.layout.helpers
  offCanvas: ->
    Session.get 'offCanvas'
  showCurtain: ->
    if Session.get 'offCanvas'
      'down'

Template.layout.events
  'click .curtain': ->
    Session.set 'offCanvas', false
