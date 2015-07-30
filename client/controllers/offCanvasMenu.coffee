Template.offCanvasMenu.helpers
  showMenu: ->
    if Session.get 'offCanvas'
      'showing'
    else
      ''

Template.offCanvasMenu.events
  'click a': () ->
    Session.set 'offCanvas', false
