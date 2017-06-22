Meteor.startup ->
  if Meteor.isCordova
    StatusBar.hide()

import '../../helpers/registered_helpers'
import './accounts'
import './router'
