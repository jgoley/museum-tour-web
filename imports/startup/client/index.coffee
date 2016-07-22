Meteor.startup ->
  if Meteor.isCordova
    StatusBar.hide()

require '../../helpers/registeredHelpers'
require './accounts'
require './router'
