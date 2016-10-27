{AccountsTemplates} = require 'meteor/useraccounts:core'

AccountsTemplates.configure
  forbidClientAccountCreation: true
  hideSignUpLink: true
  showPlaceholders: false
  homeRoutePath: '/admin'

Accounts.onLogin ->
  if FlowRouter.current().path is '/login' then FlowRouter.go '/admin'
