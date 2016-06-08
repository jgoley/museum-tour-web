{AccountsTemplates} = require 'meteor/useraccounts:core'

AccountsTemplates.configure
  forbidClientAccountCreation: true
  hideSignUpLink: false
  showPlaceholders: false
