import '../views/nav.jade'
import '../views/offCanvasMenu.jade'

Template.offCanvasMenu.onCreated ->
  @menuState = @data.menuState

Template.offCanvasMenu.helpers
  showing: ->
    Template.instance().menuState.get()

Template.offCanvasMenu.events
  'click a': (e, instance) ->
    instance.menuState.set false
