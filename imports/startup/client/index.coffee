Meteor.startup ->
  if Meteor.isCordova
    StatusBar.hide()

require '../../helpers/registered_helpers'
require './accounts'
require './router'
