Template.stopSearch.onCreated ->
  @buttonState = new ReactiveVar(true)

Template.stopSearch.events
  'keyup .stopNumber': _.throttle (e, instance)->
    if _.find(_.keys(instance.data.stopNumbers), (num) -> num is e.target.value)
      instance.buttonState.set(false)
    else
      instance.buttonState.set(true)

  'submit .goto-stop': (e, instance) ->
    e.preventDefault()
    stopNumber = e.target.stopNumber.value
    console.log instance.data.stopNumbers[stopNumber]
    Router.go('stop', {'tourID': instance.data.stopNumbers[stopNumber].tour, 'stopID': instance.data.stopNumbers[stopNumber].id})

Template.stopSearch.helpers
  buttonState: ->
    Template.instance().buttonState.get()
