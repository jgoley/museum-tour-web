if Meteor.isClient

  Template.registerHelper 'formatDate', (date) ->
    moment(date).format('YYYY-MM-DD')

  Template.registerHelper 'awsUrl', ->
    '//s3.amazonaws.com/tap-cma'
