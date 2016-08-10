{ showNotification } = require './notifications'

checkAuth = ->
  if not Meteor.userId()
    showNotification 'Not Authorized'
    throw new Meteor.Error 403, 'Not authorized'

classEvents =
  beforeUpdate: checkAuth
  beforeInsert: checkAuth
  beforeDelete: checkAuth

module.exports =
  classEvents         : classEvents
