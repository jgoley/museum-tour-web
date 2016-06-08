{Template}    = require 'meteor/templating'

require './offCanvasMenu.jade'
require './nav.jade'

Template.offCanvasMenu.helpers
  showMenu: ->
    if @menuState.get() is 'open'
      'showing'
    else
      ''

Template.offCanvasMenu.events
  'click a': (e, instance) ->
    instance.data.menuState.set 'closed'
