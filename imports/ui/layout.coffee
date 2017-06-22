import { ReactiveVar } from 'meteor/reactive-var'
import './layout.jade'

Template.layout.onCreated ->
  @menuState = new ReactiveVar false

Template.layout.helpers
  showCurtain: ->
    if Template.instance().menuState.get()
      'down'

  menuState: ->
    Template.instance().menuState

  menuOpen: ->
    Template.instance().menuState.get() or Meteor.isCordova

Template.layout.events
  'click .curtain': (e, instance) ->
    instance.menuState.set false
