if Meteor.isClient

  Template.layout.onCreated ->
    @menuState = new ReactiveVar('closed')

  Template.layout.helpers
    showCurtain: ->
      if Template.instance().menuState.get() is 'open'
        'down'
    menuState: ->
      Template.instance().menuState

  Template.layout.events
    'click .curtain': (e, instance) ->
      instance.menuState.set('closed')